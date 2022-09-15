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

/*
 * generated by Xtext 2.23.0
 */
package circus.robocalc.roboarch.textual.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper

import circus.robocalc.roboarch.textual.scoping.RoboArchIndex
import org.eclipse.emf.ecore.EObject
import org.junit.Test
import static extension org.junit.Assert.*
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import circus.robocalc.roboarch.System
import org.eclipse.xtext.scoping.IScopeProvider
import circus.robocalc.roboarch.ReactiveSkills
import org.eclipse.emf.ecore.EReference
import circus.robocalc.roboarch.RoboArchPackage
import circus.robocalc.robochart.RoboChartPackage

@RunWith(XtextRunner)
@InjectWith(RoboArchInjectorProvider)
class RoboArchScopingTest {
	
	@Inject	extension ParseHelper<System>
	@Inject extension RoboArchIndex
	
	@Inject extension IScopeProvider

	@Test
	def void reactiveSkillsMonitorIndex() {
		'''
		system ReactiveSkillsObstacleAvoidanceMonitor 
		
		type Velocity
		type Length
		datatype Velocities {linear:Velocity angular:Velocity} 
		
		layer { type: CONTROL ; 
				pattern : REACTIVE_SKILLS;
				      
				skills:  
				
					dskill{ name:Move ; 
						    actuation-commands: vIn:Velocities;
					}
					
					dskill{ name: Proximity; 
						    sensor-data: gap:Length;
					}
								
					cskill{ name: Explore; 
							parameters:	maxSpeed: Velocity,
							            safetyDistance: Length;	
							
							inputs: obstacleDistance: Length;
							
						    outputs: vOut:Velocities;
					};
					
					
				connections: { 
					Explore on vOut to Move on vIn, 
					Proximity on gap to Explore on obstacleDistance	
				} ;
				monitors : { SafetyDistanceReached [ Proximity::vIn < Explore::safetyDistance ];
		}
		'''.parse.assertExportedEObjectDescriptions("Proximity::gap, Explore::maxSpeed, Explore::safetyDistance, Explore::vOut")
	}
	
	
	
	@Test 
	def void scopeProviderTest(){
		
		var ReactiveSkills pattern =
		'''
		system ReactiveSkillsObstacleAvoidanceMonitor 
		
		type Velocity
		type Length
		datatype Velocities {linear:Velocity angular:Velocity} 
		
		layer { type: CONTROL ; 
				pattern : REACTIVE_SKILLS;
				      
				skills:  
				
					dskill{ name:Move ; 
						    actuation-commands: vIn:Velocities;
					}
					
					dskill{ name: Proximity; 
						    sensor-data: gap:Length;
					}
								
					cskill{ name: Explore; 
							parameters:	maxSpeed: Velocity,
							            safetyDistance: Length;	
							
							inputs: obstacleDistance: Length;
							
						    outputs: vOut:Velocities;
					};
					
					
				connections: { 
					Explore on vOut to Move on vIn, 
					Proximity on gap to Explore on obstacleDistance	
				} ;
				monitors : { SafetyDistanceReached [ Proximity::vIn < Explore::safetyDistance ];
		}
		'''.parse.layers.head.pattern as ReactiveSkills
		
		pattern.skillsManager.stateMonitors.head => [ assertScope(RoboChartPackage.eINSTANCE.refExp_Ref, "Proximity.gap, Explore.maxSpeed, Explore.safetyDistance, Explore.vOut, Velocity, Length, Velocities") ]
		
	}
	
	
	def private assertScope(EObject context, EReference reference, CharSequence expected) {
		expected.toString.assertEquals(context.getScope(reference).allElements.map[name].join(", "))
	}
	
	def private assertExportedEObjectDescriptions(EObject o, CharSequence expected) {
		expected.toString.assertEquals(
			o.getExportedEObjectDescriptions.map[qualifiedName].join(", ")
		)
	}
}
