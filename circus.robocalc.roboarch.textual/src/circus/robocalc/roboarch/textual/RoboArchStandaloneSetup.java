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
package circus.robocalc.roboarch.textual;

import org.eclipse.emf.ecore.EPackage;

import com.google.inject.Injector;

import circus.robocalc.roboarch.RoboArchPackage;

/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class RoboArchStandaloneSetup extends RoboArchStandaloneSetupGenerated {

	public static void doSetup() {
		new RoboArchStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
	
	//TODO: This causes a maven build error, but its need to use the standalone instance for tests.
	@Override
	public void register(Injector injector) {
		if ( !EPackage.Registry.INSTANCE.containsKey(RoboArchPackage.eNS_URI) ) {
			EPackage.Registry.INSTANCE.put(RoboArchPackage.eNS_URI, RoboArchPackage.eINSTANCE);
		}
		
		super.register(injector);
	}
}
