package hu.bme.mit.viatra2.examples.reveng.tests;

import java.io.IOException;

import hu.bme.mit.viatra2.examples.reveng.ClassCalledWithActivateMatcher;
import hu.bme.mit.viatra2.examples.reveng.transformation.ReengineeringTransformation;
import hu.bme.mit.viatra2.examples.reveng.util.ClassCalledWithActivateProcessor;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.emftext.language.java.classifiers.Class;
import org.emftext.language.java.references.IdentifierReference;
import org.emftext.language.java.references.ReferenceableElement;
import org.junit.Test;

import com.google.common.base.Joiner;

public class RevEngTest {

	@Test
	public void execute() throws IncQueryException, IOException {
		ResourceSet set = new ResourceSetImpl();

		URI uri = URI.createPlatformResourceURI("/tcp2/src/tcp2/c/Closed.java", true);
		Resource res = set.getResource(uri, true);
		Resource chartRes = set.createResource(URI.createFileURI("/Users/stampie/Documents/eclipse/runtime-EMF-IncQuery/hu.bme.mit.viatra2.examples.reveng.tests/tcp2.statemachine"));
		
//		IncQueryEngine engine = IncQueryEngine.on(set);
//		ClassCalledWithActivateMatcher.on(engine)
//			.forEachMatch(new ClassCalledWithActivateProcessor() {
//			
//			@Override
//			public void process(ReferenceableElement pActivateCallClass,
//					IdentifierReference pActivatedClassRef, Class pStateClass) {
//				System.out.println(pStateClass);
//				
//			}
//		});
		
		ReengineeringTransformation transformation = new ReengineeringTransformation(res, chartRes);
		transformation.reengineer();
		
		System.out.println(Joiner.on("\n").join(chartRes.getAllContents()));
		
		chartRes.save(null);
	}
}
