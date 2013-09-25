package hu.bme.mit.viatra2.examples.reveng.transformation

import hu.bme.mit.viatra2.examples.reveng.ClassCalledWithActivateMatcher
import hu.bme.mit.viatra2.examples.reveng.NameOfElementMatch
import hu.bme.mit.viatra2.examples.reveng.NameOfElementMatcher
import hu.bme.mit.viatra2.examples.reveng.NotAbstractStateClassMatcher
import hu.bme.mit.viatra2.examples.reveng.StateTraceMatch
import hu.bme.mit.viatra2.examples.reveng.StateTraceMatcher
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.viatra2.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra2.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra2.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra2.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra2.emf.runtime.transformation.batch.BatchTransformation
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
		
		sm = create(trgResource, stateMachine) as StateMachine
	}
	
	
	val createStateRule = createRule(NotAbstractStateClassMatcher::querySpecification) [
		println('''--> Found state class «cl.name»''')
		val state = sm.createChild(stateMachine_States, state) as State
		
		val nameMatch = NameOfElementMatcher::querySpecification.<NameOfElementMatch, NameOfElementMatcher>find("element" -> cl)
		state.set(state_Name, nameMatch.name)
		
	]

	val createTransitionRule = createRule(ClassCalledWithActivateMatcher::querySpecification) [
		println('''---> Transition found from «stateClass.name» to «activateCallClass.name»''')
		val transition = sm.createChild(stateMachine_Transitions, transition) as Transition
		val fromState = StateTraceMatcher::querySpecification.<StateTraceMatch, StateTraceMatcher>find("cl" -> stateClass).st
		val toState = StateTraceMatcher::querySpecification.<StateTraceMatch, StateTraceMatcher>find("cl" -> activateCallClass).st
		transition.set(transition_Src, fromState)
		transition.set(transition_Dst, toState)
		//transition.set(tra)
	]
	
	
	def reengineer() {
		createStateRule.forall
		createTransitionRule.forall
	}
}