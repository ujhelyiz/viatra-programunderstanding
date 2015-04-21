package hu.bme.mit.viatra2.examples.reveng.transformation

import hu.bme.mit.viatra2.examples.reveng.ClassCalledWithActivateMatcher
import hu.bme.mit.viatra2.examples.reveng.Queries
import hu.bme.mit.viatra2.examples.reveng.Trace
import org.apache.log4j.Level
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.incquery.runtime.evm.specific.resolver.ArbitraryOrderConflictResolver
import org.eclipse.viatra.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.emf.runtime.rules.eventdriven.EventDrivenTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.transformation.eventdriven.EventDrivenTransformation
import statemachine.State
import statemachine.StateMachine
import statemachine.StatemachinePackage
import statemachine.Transition
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum
import org.eclipse.incquery.runtime.emf.EMFScope

/**
 * Implementation of the Reengineering case study. 
 */
class LiveReengineeringTransformation {
	
	extension EventDrivenTransformationRuleFactory factory = new EventDrivenTransformationRuleFactory
	extension EventDrivenTransformation transformation
	extension IModelManipulations manipulation
	
	extension StatemachinePackage smPackage = StatemachinePackage::eINSTANCE
	
	extension Trace traces = Trace.instance
	extension Queries queries = Queries.instance
	
	val Resource srcResource
	val Resource trgResource
	
	var StateMachine sm
	
	new(Resource srcResource, Resource trgResource) {
		this.srcResource = srcResource
		this.trgResource = trgResource
		
		transformation = EventDrivenTransformation::forScope(new EMFScope(srcResource.resourceSet))
		manipulation = new SimpleModelManipulations(iqEngine)
		
		transformation.executionSchema.logger.level = Level::DEBUG
	}
	
	/**
	 * A rule for creating new states.
	 * </p><p>
	 * The rule is activated for non-abstract state classes. Does not check whether the
	 * class has a corresponding state already created.
	 */
	val stateSynchRule = createRule.precondition(notAbstractStateClass).action(IncQueryActivationStateEnum::APPEARED)[
		if (!iqEngine.class2State.hasMatch(cl, null)) {
			println('''--> Found state class «cl.name»''')
			val state = sm.createChild(stateMachine_States, state) as State
			state.set(state_Name, cl.name)
		}
	].action(IncQueryActivationStateEnum::DISAPPEARED) [
		//cl is a parameter of the NotAbstractStateClass pattern, representing the found class
		val st = iqEngine.class2State.getAllValuesOfst(cl).findFirst[true]
		st.remove
	].build

	/**
	 * A rule for creating new transitions.
	 * </p><p>
	 * The rule is activated for reference of the state instances. Does not
	 * check whether the source/target classes have corresponding states already created.
	 */
	val transitionSynchRule = createRule.precondition(ClassCalledWithActivateMatcher::querySpecification).action(IncQueryActivationStateEnum::APPEARED) [
		//stateClass is a parameter of the NotAbstractStateClass pattern, representing the source class
		//activateCallClass is a parameter of the NotAbstractStateClass pattern, representing the target class
		val sourceClass = stateClass
		val targetClass = activateCallClass
		
		println('''---> Transition found from «sourceClass.name» to «targetClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition
		//Finding source and target states based on traceability patterns
		val from = iqEngine.class2State.getOneArbitraryMatch(sourceClass, null)
		val to = iqEngine.class2State.getOneArbitraryMatch(targetClass, null)
		//If https://bugs.eclipse.org/bugs/show_bug.cgi?id=418498 is fixed, the following will also work
		//val from = class2StateMatcher.getOneArbitraryMatch("cl" -> stateClass)
		//val to = class2StateMatcher.getOneArbitraryMatch("cl" -> activateCallClass)
		transition.set(transition_Src, from)
		transition.set(transition_Dst, to)
	].action(IncQueryActivationStateEnum::DISAPPEARED)[
		//stateClass is a parameter of the NotAbstractStateClass pattern, representing the source class
		//activateCallClass is a parameter of the NotAbstractStateClass pattern, representing the target class
		val sourceClass = stateClass
		val targetClass = activateCallClass
		
		println('''---> Transition found from «sourceClass.name» to «targetClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition
		//Finding source and target states based on traceability patterns
		val from = iqEngine.class2State.getOneArbitraryMatch(sourceClass, null).cl
		val to = iqEngine.class2State.getOneArbitraryMatch(targetClass, null).cl
		
		iqEngine.ref2Transition.forOneArbitraryMatch(from, to, null, null)[
			transition.remove
		]
	].build
	
	/**
	 * Executes a transformation when a previous state machine has been created,
	 * and possibly new states and transitions are added. If started from scratch,
	 * it simply executes the entire transformation.
	 */
	def reengineer_transformation_live() {
		//Initializing state machine if it is not already created
		sm = trgResource.contents.filter(typeof(StateMachine)).head ?: create(trgResource, stateMachine) as StateMachine
		//Collecting all rules
		transformation.addRule(stateSynchRule)
		transformation.addRule(transitionSynchRule)
		//Trace information in preconditions express precedence
		transformation.conflictResolver = new ArbitraryOrderConflictResolver 
		//Fire all activations
		transformation.executionSchema.startUnscheduledExecution
	}
}