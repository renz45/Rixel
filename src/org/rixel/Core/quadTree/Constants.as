/*
 * Copyright (c) 2007-2008, Michael Baczynski
 * Based on Box2D by Erin Catto, http://www.box2d.org
 * 
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * * Neither the name of the polygonal nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.rixel.Core.quadTree 
{
	/**
	 * Defines world constants according to MKS.
	 */
	public class Constants
	{
		public static const k_invalid:int                  = 0xfff;

		public static const k_lengthUnitsPerMeter:Number   = 50.0;
		public static const k_massUnitsPerKilogram:Number  = 1.0;
		public static const k_timeUnitsPerSecond:Number    = 1.0;

		public static const k_contactBaumgarte:Number      = 0.2;
		public static const k_linSlop:Number               = 0.005 * k_lengthUnitsPerMeter;		public static const k_linSlopSq:Number             = k_linSlop * k_linSlop;
		public static const k_angSlop:Number               = 2 / 180 * Math.PI;

		public static const k_velocityThreshold:Number     = 1.0 * k_lengthUnitsPerMeter / k_timeUnitsPerSecond;
		public static const k_maxLinCorrection:Number      = 0.2 * k_lengthUnitsPerMeter;
		public static const k_maxAngCorrection:Number      = 8.0 / 180 * Math.PI;

		public static const k_maxManifoldPoints:int        = 2;
		public static const k_maxShapesPerBody:int         = 64;
		public static const k_maxPolyVertices:int          = 8;
		public static const k_maxProxies:int               = 3 << 9; //must be power of two
		public static const k_maxPairs:int                 = k_maxProxies << 3; //must be power of two
		public static const k_maxForceGenerators:int       = 1 << 9; //must be power of two

		public static const k_timeToSleep:Number           = 0.5 * k_timeUnitsPerSecond;
		public static const k_linSleepTolerance:Number     = 0.01 * k_lengthUnitsPerMeter / k_timeUnitsPerSecond;
		public static const k_angSleepTolerance:Number     = 2 / 180 / k_timeUnitsPerSecond;

		public static const k_linSleepToleranceSq:Number   = k_linSleepTolerance * k_linSleepTolerance;
		public static const k_angSleepToleranceSq:Number   = k_angSleepTolerance * k_angSleepTolerance;
		
		public static const k_minLineAABBThickness:Number = 20;
	}
}