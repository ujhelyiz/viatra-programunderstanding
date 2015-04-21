package hu.bme.mit.viatra2.examples.reveng.tests;

import hu.bme.mit.viatra2.examples.reveng.UnprocessedStateClassMatcher;
import hu.bme.mit.viatra2.examples.reveng.transformation.ReengineeringTransformation;
import hu.bme.mit.viatra2.examples.reveng.util.UnprocessedStateClassProcessor;

import java.io.IOException;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.incquery.runtime.emf.EMFScope;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.emftext.language.java.classifiers.Class;
import org.junit.Test;

public class RevEngTest {

	@Test
	public void execute() throws IncQueryException, IOException {
		ResourceSet set = new ResourceSetImpl();

		URI uri = URI.createPlatformResourceURI("/tcp2/src/tcp2/c/Closed.java", true);
		Resource res = set.getResource(uri, true);
		Resource chartRes = set.createResource(URI.createFileURI("/Users/stampie/git/programunderstanding-ttc2011/transformation/hu.bme.mit.viatra2.examples.reveng.tests/tcp2.statemachine"));
		
		ReengineeringTransformation transformation = new ReengineeringTransformation(res, chartRes);
		transformation.reengineer();
		
//		System.out.println(Joiner.on("\n").join(chartRes.getAllContents()));
		
		chartRes.save(null);
	}
	
	@Test
	public void execute_update() throws IncQueryException, IOException {
		ResourceSet set = new ResourceSetImpl();
		
		URI uri = URI.createPlatformResourceURI("/tcp2/src/tcp2/c/Closed.java", true);
		Resource res = set.getResource(uri, true);
		Resource chartRes = set.createResource(URI.createFileURI("/Users/stampie/git/programunderstanding-ttc2011/transformation/hu.bme.mit.viatra2.examples.reveng.tests/tcp2.inc.statemachine"));
		
		AdvancedIncQueryEngine engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(set));
		UnprocessedStateClassMatcher matcher2 = UnprocessedStateClassMatcher.on(engine);
		matcher2.forEachMatch(new UnprocessedStateClassProcessor() {
			
			@Override
			public void process(Class pCl) {
				System.out.println(pCl.getName());
				
			}
		});
		ReengineeringTransformation transformation = new ReengineeringTransformation(res, chartRes, engine);
		transformation.reengineer_update();
		
//		System.out.println(Joiner.on("\n").join(chartRes.getAllContents()));
		
		chartRes.save(null);
	}
}
