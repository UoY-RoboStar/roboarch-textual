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

/********************************************************************************
 * Copyright (c) 2019 University of York and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Alvaro Miyazawa - initial definition
 ********************************************************************************/

package circus.robocalc.roboarch.textual.scoping

import com.google.common.base.Predicate
import com.google.inject.Inject
import java.util.LinkedHashSet
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.DefaultGlobalScopeProvider
import org.eclipse.xtext.scoping.impl.ImportUriGlobalScopeProvider
import org.eclipse.xtext.scoping.impl.SimpleScope

class RoboArchImportURIGlobalScopeProvider extends ImportUriGlobalScopeProvider {
	public static final URI CORE_URI = URI.createURI("platform:/plugin/circus.robocalc.robochart.textual/lib/robochart/core.rct");
	//public static final URI SET_URI = URI.createURI("platform:/plugin/circus.robocalc.robochart.textual/lib/robochart/set_toolkit.rct");
	//public static final URI RELATION_URI = URI.createURI("platform:/plugin/circus.robocalc.robochart.textual/lib/robochart/relation_toolkit.rct");
	//public static final URI FUNCTION_URI = URI.createURI("platform:/plugin/circus.robocalc.robochart.textual/lib/robochart/function_toolkit.rct");
	//public static final URI SEQUENCE_URI = URI.createURI("platform:/plugin/circus.robocalc.robochart.textual/lib/robochart/sequence_toolkit.rct");
	
	@Inject DefaultGlobalScopeProvider dgsp;
	
	override protected LinkedHashSet<URI> getImportedUris(Resource resource) {
		val importedURIs = super.getImportedUris(resource);
		importedURIs.add(CORE_URI);
		//importedURIs.add(SET_URI);
		//importedURIs.add(RELATION_URI);
		//importedURIs.add(FUNCTION_URI);
		//importedURIs.add(SEQUENCE_URI);
		return importedURIs;
	}
}