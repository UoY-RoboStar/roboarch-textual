/********************************************************************************
 * Copyright (c) 2022 University of York and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   William Barnett - initial definition
 ********************************************************************************/

package circus.robocalc.roboarch.textual.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import circus.robocalc.roboarch.System
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import circus.robocalc.roboarch.RoboArchPackage
import circus.robocalc.roboarch.textual.validation.RoboArchValidator

@ExtendWith(InjectionExtension)
@InjectWith(RoboArchInjectorProvider)
class RoboArchValidationTest {
	
	@Inject	extension ParseHelper<System> parseHelper
	@Inject extension ValidationTestHelper
	


/*
 *  S1: The robotic platform is used 
 */
 
	@Test
	def void testRoboticPlatformIsUsed() {
		// Platform not used
		'''
			system ThreeEmptyLayers
			
			layer c1: ControlLayer { } ;	 

			robotic platform rp1 { } 
		'''.parse.assertPlatformIsUsed()
	} 
	 
	@Test
	def void testNotRoboticPlatformIsUsedConnection() {
		// Platform used via connection of events
		'''
			system ThreeEmptyLayers
			
			interface i1 { event ro: int  } 
			
			layer c1: ControlLayer { 
				outputs = o1: int ;
			} ;	 
			
			connections =  c1 on o1 to rp1 on ro ;
			
			robotic platform rp1 { 
				uses i1
} 
		'''.parse.assertNoPlatformIsUsed()
	}	 
	 
	@Test
	def void testNotRoboticPlatformIsUsedInterface() {
		// Platform used via interface
		'''
			system ThreeEmptyLayers
			
			interface i2 { var  vr: nat  } 
			
			layer c1: ControlLayer { 
				requires i2
			} ;	 
			
			robotic platform rp1 { 
				provides i2
			} 
		'''.parse.assertNoPlatformIsUsed()
	}
	
	def private assertPlatformIsUsed(System sys){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.ROBOTIC_PLATFORM_UNUSED,
			"The robotic platform must be used."
		)
	}	 	 

	
	def private assertNoPlatformIsUsed(System sys){
		sys.assertNoError(RoboArchValidator.ROBOTIC_PLATFORM_UNUSED)
	}	 


	
/*
 *  S2: There are no unused layers.
 */
	 
	@Test
	def void testNotUnusedLayerInput() {
		'''
			system stest
			
			layer c: ControlLayer { 
				inputs = a; 
			} ;	 
			
			layer e { 
				inputs = a; 
			} ;    
		'''.parse.assertNoUnusedLayer()
	}

	@Test
	def void testNotUnusedLayerOutput() {
		'''
			system stest
			
			layer c: ControlLayer { 
				outputs = a; 
			} ;	 
			
			layer e { 
				outputs = a; 
			} ;    
		'''.parse.assertNoUnusedLayer()
	}

	
	
	@Test
	def void testUnusedLayerE() {
		'''
			system stest
			
			layer c: ControlLayer { 
				inputs = a; 
			} ;	 
			
			layer e { 
			} ;    
		'''.parse.assertUnusedLayer("e")
	}
	 
	
	@Test
	def void testUnusedLayerC() {
		'''
			system stest
			
			layer c: ControlLayer { 
			} ;	 
			
			layer e { 
				inputs = a; 
			} ;    
		'''.parse.assertUnusedLayer("c")
	}
	 

	def private assertUnusedLayer(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.layer,
			RoboArchValidator.LAYER_WITHOUT_IO,
			"Layer '" + layerName + "' has no inputs or outputs."
		)
	}	 	 
	 
	def private assertNoUnusedLayer(System sys){
		sys.assertNoError(RoboArchValidator.LAYER_WITHOUT_IO)
	}		 
	 


/*
 *  S3: The order of layer types must be Control > Executive > Planning.
 */
 	@Test
	def void testNotLayerOrder() {
		//Correctly connected ordered layers no error is raised.
	'''
		system stest
		
		
		layer p: PlanningLayer { 
			inputs = pi1;
		 	outputs = po1;
		 	
		 	};  
		
		
		layer e: ExecutiveLayer { 
			outputs = eo2;
			inputs = ei1, ei2;
		} ;	 
		
		
		layer g1 { 
			outputs = g1o1, g1o2; 
			inputs = g1i1, g1i2;
		} ;  
		
		
		layer g2 { 
			outputs = g2o1, g2o2;
			inputs = g2i1, g2i2;
		} ; 
		  
		layer c: ControlLayer { 
			outputs = co1, co2;
			 inputs = ci1;
		} ;	 
		
		
		connections =  
		    c on co1 to g2 on g2i1,
		    c on co2 to g2 on g2i2, 
		    
		    g2 on g2o1 to g1 on g1i1,
		    g2 on g2o2 to g1 on g1i2, 
		    
		    g1 on g1o1 to e on ei1, 
		    g1 on g1o2 to e on ei2, 
		    
		    e on eo2 to p on pi1;
		       
		'''.parse.assertNoLayerOrder();
	}
 
 
 	@Test
	def void testLayerOrderDirect() {
		// Incorrectly ordered layers with direct connection between planning 
		// and control layer the correct error is raised.
	'''
		system stest
		
		
		layer p: PlanningLayer { 
			inputs = pi1;
		 	outputs = po1;
		 	
		 	};  
		
		
		layer e: ExecutiveLayer { 
			outputs = eo2;
			inputs = ei1, ei2;
		} ;	 
		
		
		layer g1 { 
			outputs = g1o1, g1o2; 
			inputs = g1i1, g1i2;
		} ;  
		
		
		layer g2 { 
			outputs = g2o1, g2o2;
			inputs = g2i1, g2i2;
		} ; 
		  
		layer c: ControlLayer { 
			outputs = co1, co2;
			 inputs = ci1;
		} ;	 
		

		connections =  
		    c on co1 to g2 on g2i1,
		    c on co2 to g2 on g2i2, 
		    
		    g2 on g2o1 to g1 on g1i1,
		    g2 on g2o2 to g1 on g1i2, 
		    
		    g1 on g1o1 to e on ei1, 
		    g1 on g1o2 to e on ei2, 
		    
		    e on eo2 to p on pi1, 
		     
		     
		     
		     p on po1 to c on ci1;     // Direct connection
		     
		'''.parse.assertLayerOrder();
		
	}
	
	@Test
	def void testLayerOrderViaGeneric() {
		// Incorrectly ordered layers with indirect connection between planning 
		// and control layer via generic layer the correct error is raised.
	'''
		system stest
		
		
		layer p: PlanningLayer { 
			inputs = pi1;
		 	outputs = po1;
		 	
		 	};  
		
		
		layer e: ExecutiveLayer { 
			outputs = eo2;
			inputs = ei1, ei2;
		} ;	 
		
		
		layer g1 { 
			outputs = g1o1, g1o2; 
			inputs = g1i1, g1i2;
		} ;  
		
		
		layer g2 { 
			outputs = g2o1, g2o2;
			inputs = g2i1, g2i2;
		} ; 
		  
		layer c: ControlLayer { 
			outputs = co1, co2;
			 inputs = ci1;
		} ;	 
		
		layer g3 { 
			outputs = g3o1;
			inputs = g3i1;
		} ; 
		
		connections =  
		    c on co1 to g2 on g2i1,
		    c on co2 to g2 on g2i2, 
		    
		    g2 on g2o1 to g1 on g1i1,
		    g2 on g2o2 to g1 on g1i2, 
		    
		    g1 on g1o1 to e on ei1, 
		    g1 on g1o2 to e on ei2, 
		    
		    e on eo2 to p on pi1, 
		     
		     
		     
		     g3 on g3o1 to c on ci1,  // Indirect connection via g3 
		     p on po1 to g3 on g3i1;   
		'''.parse.assertLayerOrder();
	}
	
	def private assertLayerOrder(System sys){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.LAYER_ORDER_INVALID,
			"The ordering of layer types ignoring generic types must be Control < Executive < Planning."
		)
	}	 	 

	
	def private assertNoLayerOrder(System sys){
		sys.assertNoError(RoboArchValidator.LAYER_ORDER_INVALID)
	}		
	
	
	
	
	
	
	
	
	
	
/*
 *  The layers of a system must be distinct.
 */
 
	@Test
	def void testLayersAreDistinctTypes() {
		'''
			system maildelivery 

			layer lyr1 : PlanningLayer {  };
			layer lyr2 : ControlLayer {  };
			layer lyr3 : ControlLayer {  };
			
		'''.parse.assertLayersAreDistinctTypes("lyr3")
	}

	def private assertLayersAreDistinctTypes(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.LAYERS_NOT_DISTINCT_TYPES,
			"Duplicate layer type '"+ layerName +"'. Layers must be distinct types."
		)
	}
	
	
	
	
	
	def private assertRoboticPlatformUnused(System sys, String platformName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.ROBOTIC_PLATFORM_UNUSED,
			"The robotic platform '"+ platformName +"' is not used by any layer."
		)
	}

	def private assertLayerWithoutIO(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.LAYER_WITHOUT_IO,
			"Layer '"+ layerName +"' has no inputs or outputs."
		)
	}
	
	def private assertLayerOrderIvalid(System sys){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.LAYER_ORDER_INVALID,
			"The order of layers the connections impose is invalid. It must be Planning <> Executive <> Control."
		)
	}
	
	def private assertConnectionEventTypes(System sys, String typeA, String typeB){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.CONNECTION_EVENT_TYPES,
			"The source type '"+ typeA +"' of the connection does not match its destination type '"+ typeB +"'."
		)
	}	
	
	def private assertConnectionsAssociationsLayers(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.CONNECTION_ASSOCIATIONS_LAYERS,
			"Layer '"+ layerName +"' is associated more than two other layers."
		)
	}
	

	def private assertConnectionsAssociationsControlLayer(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.CONNECTION_ASSOCIATIONS_CONTROLLAYER,
			"The ControLayer '"+ layerName +"' is associated with more than one other layer."
		)
	}
	
	def private assertConnectionsPlatformAssociation(System sys, String layerName){
		sys.assertError(
			RoboArchPackage.eINSTANCE.system,
			RoboArchValidator.CONNECTIONS_PLATFORM_ASSOCIATION,
			"The connection associates the event '"+ layerName +"' of interface '"+ layerName +"' with a layer that is not a GenericLayer or a ControlLayer."
		)
	}
	
	
	
}

