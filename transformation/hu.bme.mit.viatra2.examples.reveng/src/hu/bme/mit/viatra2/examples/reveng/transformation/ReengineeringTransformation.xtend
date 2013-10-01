package hu.bme.mit.viatra2.examples.reveng.transformation

import hu.bme.mit.viatra2.examples.reveng.ClassCalledWithActivateMatcher
import hu.bme.mit.viatra2.examples.reveng.NameOfElementMatch
import hu.bme.mit.viatra2.examples.reveng.NameOfElementMatcher
import hu.bme.mit.viatra2.examples.reveng.NotAbstractStateClassMatcher
import hu.bme.mit.viatra2.examples.reveng.StateTraceMatch
import hu.bme.mit.viatra2.examples.reveng.StateTraceMatcher
import hu.bme.mit.viatra2.examples.reveng.UnprocessedStateClassMatcher
import hu.bme.mit.viatra2.examples.reveng.UnprocessedTransitionMatcher
import org.apache.log4j.Level
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.viatra2.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra2.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra2.emf.runtime.rules.TransformationRuleGroup
import org.eclipse.viatra2.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra2.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra2.emf.runtime.transformation.batch.BatchTransformation
import org.emftext.language.java.classifiers.Class
import statemachine.State
import statemachine.StateMachine
import statemachine.StatemachinePackage
import statemachine.Transition

/**
 * Implementation of the Reengineering case study. 
 */
class ReengineeringTransformation {
	
	extension BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	extension IModelManipulations manipulation
	
	extension StatemachinePackage smPackage = StatemachinePackage::eINSTANCE
	
	val Resource srcResource
	val Resource trgResource
	
	var StateMachine sm
	
	new(Resource srcResource, Resource trgResource) {
		this.srcResource = srcResource
		this.trgResource = trgResource
		
		transformation = new BatchTransformation(srcResource.resourceSet)
		statements = new BatchTransformationStatements(transformation)
		manipulation = new SimpleModelManipulations(transformation.iqEngine)
		
		transformation.ruleEngine.logger.level = Level::DEBUG
	}
	
	/**
	 * A rule for creating new states. Does not rely on trace patterns.
	 */
	val createStateRule = createRule(NotAbstractStateClassMatcher::querySpecification) [
		createState(cl)	
	]

	/**
	 * A rule for creating new transitions. Does not rely on trace patterns.
	 */
	val createTransitionRule = createRule(ClassCalledWithActivateMatcher::querySpecification) [
		createTransition(stateClass, activateCallClass)
	]
	
	/**
	 * A rule for creating new states. Disabled if trace pattern already matches (a state is created from the selected class).
	 */
	val createUnprocessedStateRule = createRule(UnprocessedStateClassMatcher::querySpecification) [
		createState(cl)
	]
	
	/**
	 * A rule for creating new transitions. Disabled if trace pattern already matches (a transition is created from the current call).
	 */
	val createUnprocessedTransitionRule = createRule(UnprocessedTransitionMatcher::querySpecification) [
		createTransition(stateClass, activateCallClass)
	]
	
	private def createState(Class cl) {
		println('''--> Found state class «cl.name»''')
		val state = sm.createChild(stateMachine_States, state) as State
		
		val NameOfElementMatch nameMatch = NameOfElementMatcher::querySpecification.find("element" -> cl)
		state.set(state_Name, nameMatch.name)
	}
	
	private def createTransition(Class stateClass, Class activateCallClass) {
		println('''---> Transition found from «stateClass.name» to «activateCallClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition
		val StateTraceMatch fromMatch = StateTraceMatcher::querySpecification.find("cl" -> stateClass)
		val StateTraceMatch toMatch = StateTraceMatcher::querySpecification.find("cl" -> activateCallClass)
		transition.set(transition_Src, fromMatch.st)
		transition.set(transition_Dst, toMatch.st)
	}
	
	def reengineer() {
		sm = create(trgResource, stateMachine) as StateMachine
		createStateRule.fireAllCurrent
		createTransitionRule.fireAllCurrent
	}
	
	def reengineer_update() {
		//Initializing state machine if it is not already created
		sm = trgResource.contents.filter(typeof(StateMachine)).head ?: create(trgResource, stateMachine) as StateMachine
		val group = new TransformationRuleGroup(createUnprocessedStateRule, createUnprocessedTransitionRule)
		group.fireWhilePossible
	}
}