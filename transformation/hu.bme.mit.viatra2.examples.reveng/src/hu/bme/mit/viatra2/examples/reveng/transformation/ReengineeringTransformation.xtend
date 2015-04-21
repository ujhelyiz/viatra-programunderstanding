package hu.bme.mit.viatra2.examples.reveng.transformation

import hu.bme.mit.viatra2.examples.reveng.ClassCalledWithActivateMatcher
import hu.bme.mit.viatra2.examples.reveng.NotAbstractStateClassMatcher
import hu.bme.mit.viatra2.examples.reveng.StateWithoutClassMatcher
import hu.bme.mit.viatra2.examples.reveng.Trace
import hu.bme.mit.viatra2.examples.reveng.TransitionWithoutReferenceMatcher
import hu.bme.mit.viatra2.examples.reveng.UnprocessedStateClassMatcher
import hu.bme.mit.viatra2.examples.reveng.UnprocessedTransitionMatcher
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.RuleEngines
import org.eclipse.incquery.runtime.evm.specific.resolver.ArbitraryOrderConflictResolver
import org.eclipse.viatra.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.emf.runtime.rules.TransformationRuleGroup
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation
import org.emftext.language.java.classifiers.Class
import statemachine.State
import statemachine.StateMachine
import statemachine.StatemachinePackage
import statemachine.Transition
import org.eclipse.incquery.runtime.emf.EMFScope
import org.eclipse.incquery.runtime.exception.IncQueryException

/**
 * Implementation of the Reengineering case study. 
 */
class ReengineeringTransformation {

	extension BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	extension IModelManipulations manipulation

	extension StatemachinePackage smPackage = StatemachinePackage::eINSTANCE

	extension Trace traces = Trace.instance

	val Resource srcResource
	val Resource trgResource

	var StateMachine sm

	new(Resource srcResource, Resource trgResource) throws IncQueryException {
		this(srcResource, trgResource, AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(srcResource.resourceSet)))
	}
	
	new(Resource srcResource, Resource trgResource, AdvancedIncQueryEngine engine) {
		this.srcResource = srcResource
		this.trgResource = trgResource

		transformation = BatchTransformation.forRuleEngine(RuleEngines.createIncQueryRuleEngine(engine), engine)
		statements = new BatchTransformationStatements(transformation)
		manipulation = new SimpleModelManipulations(iqEngine)

//		transformation.ruleEngine.logger.level = Level::DEBUG
	}

	/**
	 * A rule for creating new states.
	 * </p><p>
	 * The rule is activated for non-abstract state classes. Does not check whether the
	 * class has a corresponding state already created.
	 */
	val createStateRule = createRule.precondition(NotAbstractStateClassMatcher::querySpecification).action [
		//cl is a parameter of the NotAbstractStateClass pattern, representing the found class
		createState(cl)
	].build

	/**
	 * A rule for creating new transitions.
	 * </p><p>
	 * The rule is activated for reference of the state instances. Does not
	 * check whether the source/target classes have corresponding states already created.
	 */
	val createTransitionRule = createRule.precondition(ClassCalledWithActivateMatcher::querySpecification).action [
		//stateClass is a parameter of the NotAbstractStateClass pattern, representing the source class
		//activateCallClass is a parameter of the NotAbstractStateClass pattern, representing the target class
		createTransition(stateClass, activateCallClass)
	].build

	/**
	 * A rule for creating new states.
	 * </p><p>
	 * Its precondition extends the precondition of {@link #createStateRule} with trace information.
	 * </p><p>
	 * The rule is activated for non-abstract state classes that do not 
	 * have a corresponding state already created.
	 */
	val createUnprocessedStateRule = createRule.precondition(UnprocessedStateClassMatcher::querySpecification).action [
		//cl is a parameter of the UnprocessedStateClass pattern, representing the found class
		createState(cl)
	].build

	/**
	 * A rule for creating new transitions.
	 * </p><p>
	 * Its precondition extends the precondition of the {@link #createTransitionRule} rule with
	 * <ol>
	 *   <li>Checks whether the source/target classes have corresponding states</li>
	 *   <li>Checks that no transition is created for the found reference</li>
	 * </ol>
	 * </p><p>
	 * The rule is activated for reference of the state instances.
	 */
	val createUnprocessedTransitionRule = createRule.precondition(UnprocessedTransitionMatcher::querySpecification).
		action [
			//stateClass is a parameter of the NotAbstractStateClass pattern, representing the source class
			//activateCallClass is a parameter of the NotAbstractStateClass pattern, representing the target class
			createTransition(stateClass, activateCallClass)
		].build

	val removeUnnecessaryStateRule = createRule.precondition(StateWithoutClassMatcher::querySpecification).action [
		//st is a parameter of the StateWithoutClass pattern, representing the state without a source class
		st.remove
	].build

	val removeUnnecessaryTransitionRule = createRule.precondition(TransitionWithoutReferenceMatcher::querySpecification).
		action [
			//t is a parameter of the StateWithoutClass pattern, representing the transition without a source reference
			t.remove
		].build

	private def createState(Class cl) {
		println('''--> Found state class «cl.name»''')
		val state = sm.createChild(stateMachine_States, state) as State
		state.set(state_Name, cl.name)
	}

	private def createTransition(Class sourceClass, Class targetClass) {
		println('''---> Transition found from «sourceClass.name» to «targetClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition

		//Finding source and target states based on traceability patterns
		val from = iqEngine.class2State.getOneArbitraryMatch(sourceClass, null)
		val to = iqEngine.class2State.getOneArbitraryMatch(targetClass, null)

		//If https://bugs.eclipse.org/bugs/show_bug.cgi?id=418498 is fixed, the following will also work
		//val from = class2StateMatcher.getOneArbitraryMatch("cl" -> stateClass)
		//val to = class2StateMatcher.getOneArbitraryMatch("cl" -> activateCallClass)
		transition.set(transition_Src, from.st)
		transition.set(transition_Dst, to.st)
	}

	/**
	 * Creates the state machine from the input model. Always creates an entirely new state machine.
	 */
	def reengineer() {

		//Initialize state machine
		sm = create(trgResource, stateMachine) as StateMachine

		//Create all states from state classes
		createStateRule.fireAllCurrent

		//Create all transitions between states
		createTransitionRule.fireAllCurrent
	}

	/**
	 * Executes a transformation when a previous state machine has been created,
	 * and possibly new states and transitions are added. If started from scratch,
	 * it simply executes the entire transformation.
	 */
	def reengineer_update() {

		//Initializing state machine if it is not already created
		sm = trgResource.contents.filter(typeof(StateMachine)).head ?: create(trgResource, stateMachine) as StateMachine

		//Collecting all rules
		val group = new TransformationRuleGroup(
			createUnprocessedStateRule,
			createUnprocessedTransitionRule,
			removeUnnecessaryStateRule,
			removeUnnecessaryTransitionRule
		)

		//Trace information in preconditions express precedence
		ruleEngine.conflictResolver = new ArbitraryOrderConflictResolver

		//Fire all activations
		group.fireWhilePossible
	}
}
