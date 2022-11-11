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

