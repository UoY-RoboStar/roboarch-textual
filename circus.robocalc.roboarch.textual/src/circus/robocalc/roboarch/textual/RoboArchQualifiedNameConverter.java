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

package circus.robocalc.roboarch.textual;

import org.eclipse.xtext.naming.IQualifiedNameConverter;

// TODO Use RoboChart qualified name converter when the Expression Qualified name clash is fixed in the RoboChart syntax.
 

public class RoboArchQualifiedNameConverter extends IQualifiedNameConverter.DefaultImpl {
	@Override
	public String getDelimiter() {
		return "¦¦";
	}
}