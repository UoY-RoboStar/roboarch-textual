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

package circus.robocalc.roboarch.textual.validation;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.EcoreUtil2;

import circus.robocalc.roboarch.Layer;
import circus.robocalc.roboarch.Monitor;
import circus.robocalc.roboarch.PlatformCommunicator;
import circus.robocalc.roboarch.RoboArchPackage;
import circus.robocalc.roboarch.Skill;
import circus.robocalc.roboarch.SkillConnection;
import circus.robocalc.robochart.Event;
import circus.robocalc.robochart.Interface;
import circus.robocalc.robochart.RoboChartPackage;
import circus.robocalc.robochart.RoboticPlatform;
import circus.robocalc.robochart.RoboticPlatformDef;
import circus.robocalc.robochart.Variable;
import circus.robocalc.robochart.Connection;
import circus.robocalc.robochart.ConnectionNode;

import static org.eclipse.xtext.EcoreUtil2.getContainerOfType;
import static circus.robocalc.roboarch.util.Model.getSkillConnectionInputEvents;
import static circus.robocalc.roboarch.util.Model.getSkillConnectionOutputEvents;

import java.util.ArrayList;
import java.util.List;

import static org.eclipse.xtext.EcoreUtil2.getAllContentsOfType;

public class RoboArchAccessibility{
	
	//TODO New structure of scoping makes these unnecessary
	public boolean isAccessibleFrom(EObject member, EObject context, EReference reference) {
		
		boolean acessible;
		
		if (context instanceof SkillConnection) { 
			SkillConnection sConnection = (SkillConnection) context;
			List<Variable> skillDatas;
				
			if ( reference == RoboArchPackage.Literals.SKILL_CONNECTION__END_INPUT) {
				
				skillDatas =  getSkillConnectionInputEvents( sConnection.getEnd() );
				acessible = skillDatas.contains(member);

				 
			} else if( reference == RoboArchPackage.Literals.SKILL_CONNECTION__START_OUTPUT){
				
				skillDatas =  getSkillConnectionOutputEvents( sConnection.getStart() );
				acessible = skillDatas.contains(member);	
				
			
			} else {
				acessible = false;
			}
			
		}else if (context instanceof Monitor){
			
			if ( member.eContainer() instanceof Skill ) {
				Skill containingSkill = (Skill) member.eContainer();
				
				//All of a skills output events and parameters
				List<Variable> skillDatas = getSkillConnectionOutputEvents( containingSkill );
				skillDatas.addAll( containingSkill.getParameters() );
				
				acessible = skillDatas.contains(member);	
				
			} else {
				acessible = false;
			}
				
		}else if (context instanceof Connection){
			Connection sConnection = (Connection) context;
			List<EObject> events =  new ArrayList<EObject>(); ;
				
			if ( reference == RoboChartPackage.Literals.CONNECTION__EFROM) {
				events.addAll( sConnection.getFrom().eContents() ) ;
				events.addAll( getPlatformEvents( sConnection.getFrom() ) );
				events.addAll( getCommunicatorEvents( sConnection.getFrom() ) ); 
				acessible = events.contains(member);

				 
			} else if( reference == RoboChartPackage.Literals.CONNECTION__ETO){
				
				events.addAll( sConnection.getTo().eContents() );
				events.addAll( getPlatformEvents( sConnection.getTo() ) );
				events.addAll( getCommunicatorEvents(sConnection.getTo() ) );
				acessible = events.contains(member);	
				
			
			} else {
				acessible = false;
			}			

			
		} else {
			acessible = true;
		}

		return acessible;
	}
	
	// Returns the platform events if the object is a RoboticPlatformDef 
	private List<EObject> getPlatformEvents (EObject object) {
		
		List<EObject> events = new ArrayList<EObject>(); 
		
	    if ( object instanceof RoboticPlatformDef ) {
	    	RoboticPlatformDef platform = (RoboticPlatformDef) object;
	    	
	    	for ( Interface i: platform.getInterfaces() ){
	    		events.addAll( i.getEvents() );
	    	}
	    }
	    return events;
	}
	
	
	// Returns the communicator events if the object is a RoboticPlatformDef 
	private List<EObject> getCommunicatorEvents (EObject object) {
		
		List<EObject> events = new ArrayList<EObject>(); 
		
	    if ( object instanceof PlatformCommunicator ) {
	    	PlatformCommunicator communicator = (PlatformCommunicator) object;
	    	
	    	for ( Interface i: communicator.getInterfaces() ){
	    		events.addAll( i.getEvents() );
	    	}
	    }
	    return events;
	}
}