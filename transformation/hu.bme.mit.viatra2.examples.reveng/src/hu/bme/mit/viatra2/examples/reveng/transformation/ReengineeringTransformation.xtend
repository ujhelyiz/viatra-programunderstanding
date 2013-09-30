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

class ReengineeringTransformation {
	
	extension BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	extension IModelManipulations manipulation
	
	extension StatemachinePackage smPackage = StatemachinePackage::eINSTANCE
	
	val Resource srcResource
	val Resource trgResource
	
	val StateMachine sm
	
	new(Resource srcResource, Resource trgResource) {
		this.srcResource = srcResource
		this.trgResource = trgResource
		
		transformation = new BatchTransformation(srcResource.resourceSet)
		statements = new BatchTransformationStatements(transformation)
		manipulation = new SimpleModelManipulations(transformation.iqEngine)
		
		transformation.ruleEngine.logger.level = Level::DEBUG
		
		sm = create(trgResource, stateMachine) as StateMachine
	}
	
	
	val createStateRule = createRule(NotAbstractStateClassMatcher::querySpecification) [
		createState(cl)	
	]

	val createTransitionRule = createRule(ClassCalledWithActivateMatcher::querySpecification) [
		createTransition(stateClass, activateCallClass)
	]
	
	val createUnprocessedStateRule = createRule(UnprocessedStateClassMatcher::querySpecification) [
		createState(cl)
	]
	
	val createUnprocessedTransitionRule = createRule(UnprocessedTransitionMatcher::querySpecification) [
		createTransition(stateClass, activateCallClass)
	]
	
	private def createState(Class cl) {
		println('''--> Found state class «cl.name»''')
		val state = sm.createChild(stateMachine_States, state) as State
		
		val nameMatch = NameOfElementMatcher::querySpecification.<NameOfElementMatch, NameOfElementMatcher>find("element" -> cl)
		state.set(state_Name, nameMatch.name)
	}
	
	private def createTransition(Class stateClass, Class activateCallClass) {
		println('''---> Transition found from «stateClass.name» to «activateCallClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition
		val fromState = StateTraceMatcher::querySpecification.<StateTraceMatch, StateTraceMatcher>find("cl" -> stateClass).st
		val toState = StateTraceMatcher::querySpecification.<StateTraceMatch, StateTraceMatcher>find("cl" -> activateCallClass).st
		transition.set(transition_Src, fromState)
		transition.set(transition_Dst, toState)
	}
	
	def reengineer() {
		createStateRule.fireAllCurrent
		createTransitionRule.fireAllCurrent
	}
	
	def reengineer_update() {
		val group = new TransformationRuleGroup(createUnprocessedStateRule, createUnprocessedTransitionRule)
		group.fireWhilePossible
	}
}