/**
 */
package statemachine;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>State</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link statemachine.State#getName <em>Name</em>}</li>
 *   <li>{@link statemachine.State#getOut <em>Out</em>}</li>
 *   <li>{@link statemachine.State#getIn <em>In</em>}</li>
 *   <li>{@link statemachine.State#getSource <em>Source</em>}</li>
 * </ul>
 * </p>
 *
 * @see statemachine.StatemachinePackage#getState()
 * @model
 * @generated
 */
public interface State extends EObject {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see statemachine.StatemachinePackage#getState_Name()
	 * @model
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link statemachine.State#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Out</b></em>' reference list.
	 * The list contents are of type {@link statemachine.Transition}.
	 * It is bidirectional and its opposite is '{@link statemachine.Transition#getSrc <em>Src</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Out</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Out</em>' reference list.
	 * @see statemachine.StatemachinePackage#getState_Out()
	 * @see statemachine.Transition#getSrc
	 * @model opposite="src"
	 * @generated
	 */
	EList<Transition> getOut();

	/**
	 * Returns the value of the '<em><b>In</b></em>' reference list.
	 * The list contents are of type {@link statemachine.Transition}.
	 * It is bidirectional and its opposite is '{@link statemachine.Transition#getDst <em>Dst</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>In</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In</em>' reference list.
	 * @see statemachine.StatemachinePackage#getState_In()
	 * @see statemachine.Transition#getDst
	 * @model opposite="dst"
	 * @generated
	 */
	EList<Transition> getIn();

	/**
	 * Returns the value of the '<em><b>Source</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Source</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Source</em>' reference.
	 * @see statemachine.StatemachinePackage#getState_Source()
	 * @model transient="true" changeable="false" volatile="true" derived="true"
	 *        annotation="org.eclipse.incquery.querybasedfeature patternFQN='hu.bme.mit.viatra2.examples.reveng.stateTrace'"
	 * @generated
	 */
	org.emftext.language.java.classifiers.Class getSource();

} // State
