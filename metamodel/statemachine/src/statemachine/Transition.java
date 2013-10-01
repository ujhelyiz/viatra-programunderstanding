/**
 */
package statemachine;

import org.eclipse.emf.ecore.EObject;
import org.emftext.language.java.references.IdentifierReference;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Transition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link statemachine.Transition#getAction <em>Action</em>}</li>
 *   <li>{@link statemachine.Transition#getTrigger <em>Trigger</em>}</li>
 *   <li>{@link statemachine.Transition#getSrc <em>Src</em>}</li>
 *   <li>{@link statemachine.Transition#getDst <em>Dst</em>}</li>
 *   <li>{@link statemachine.Transition#getSource <em>Source</em>}</li>
 * </ul>
 * </p>
 *
 * @see statemachine.StatemachinePackage#getTransition()
 * @model
 * @generated
 */
public interface Transition extends EObject {
	/**
	 * Returns the value of the '<em><b>Action</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Action</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Action</em>' attribute.
	 * @see #setAction(String)
	 * @see statemachine.StatemachinePackage#getTransition_Action()
	 * @model
	 * @generated
	 */
	String getAction();

	/**
	 * Sets the value of the '{@link statemachine.Transition#getAction <em>Action</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Action</em>' attribute.
	 * @see #getAction()
	 * @generated
	 */
	void setAction(String value);

	/**
	 * Returns the value of the '<em><b>Trigger</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Trigger</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Trigger</em>' attribute.
	 * @see #setTrigger(String)
	 * @see statemachine.StatemachinePackage#getTransition_Trigger()
	 * @model
	 * @generated
	 */
	String getTrigger();

	/**
	 * Sets the value of the '{@link statemachine.Transition#getTrigger <em>Trigger</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Trigger</em>' attribute.
	 * @see #getTrigger()
	 * @generated
	 */
	void setTrigger(String value);

	/**
	 * Returns the value of the '<em><b>Src</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link statemachine.State#getOut <em>Out</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Src</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Src</em>' reference.
	 * @see #setSrc(State)
	 * @see statemachine.StatemachinePackage#getTransition_Src()
	 * @see statemachine.State#getOut
	 * @model opposite="out" required="true"
	 * @generated
	 */
	State getSrc();

	/**
	 * Sets the value of the '{@link statemachine.Transition#getSrc <em>Src</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Src</em>' reference.
	 * @see #getSrc()
	 * @generated
	 */
	void setSrc(State value);

	/**
	 * Returns the value of the '<em><b>Dst</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link statemachine.State#getIn <em>In</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Dst</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Dst</em>' reference.
	 * @see #setDst(State)
	 * @see statemachine.StatemachinePackage#getTransition_Dst()
	 * @see statemachine.State#getIn
	 * @model opposite="in" required="true"
	 * @generated
	 */
	State getDst();

	/**
	 * Sets the value of the '{@link statemachine.Transition#getDst <em>Dst</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Dst</em>' reference.
	 * @see #getDst()
	 * @generated
	 */
	void setDst(State value);

	/**
	 * Returns the value of the '<em><b>Source</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Source</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Source</em>' reference.
	 * @see statemachine.StatemachinePackage#getTransition_Source()
	 * @model transient="true" changeable="false" volatile="true" derived="true"
	 *        annotation="org.eclipse.incquery.querybasedfeature patternFQN='hu.bme.mit.viatra2.examples.reveng.transitionTrace'"
	 * @generated
	 */
	IdentifierReference getSource();

} // Transition
