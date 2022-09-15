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

package circus.robocalc.roboarch.textual.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import circus.robocalc.roboarch.RoboArchPackage
import circus.robocalc.robochart.RoboChartPackage

class RoboArchIndex {
	@Inject ResourceDescriptionsProvider rdp
	@Inject IContainer.Manager cm

	def getVisibleExternalLayerDescriptions(EObject o) {
		val allVisibleLayers =
			o.getVisibleLayerDescriptions
		val allExportedLayers =
			o.getExportedLayersEObjectDescriptions
		val difference = allVisibleLayers.toSet
		difference.removeAll(allExportedLayers.toSet)
		return difference.toMap[qualifiedName]
	}

	def getVisibleLayerDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(RoboArchPackage.eINSTANCE.layer)
	}
	
	def getVisibleTypeDeclDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(RoboChartPackage.eINSTANCE.typeDecl)
	}

	def getVisibleEObjectDescriptions(EObject o, EClass type) {
		o.getVisibleContainers.map [ container |
			container.getExportedObjectsByType(type)
		].flatten
	}

	def getVisibleContainers(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		val rd = index.getResourceDescription(o.eResource.URI)
		cm.getVisibleContainers(rd, index)
	}

	def getResourceDescription(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}

	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}

	def getExportedLayersEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjectsByType(RoboArchPackage.eINSTANCE.layer)
	}
	
	def getExportedTypeDeclEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjectsByType(RoboChartPackage.eINSTANCE.typeDecl)
	}

}
