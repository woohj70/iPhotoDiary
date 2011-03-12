/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "KLCalendarModel.h"
#import "THCalendarInfo.h"
#import "KLDate.h"

static const char _info_array[203][12] =
{
	/* 1841 */    
	1, 2, 4, 1, 1, 2,    1, 2, 1, 2, 2, 1,
	2, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    4, 1, 2, 1, 2, 1,
	2, 2, 1, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 5, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 3, 2, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	
	/* 1851 */    
	2, 2, 1, 2, 1, 1,    2, 1, 2, 1, 5, 2,
	2, 1, 2, 2, 1, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    5, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 5, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 6, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	
	/* 1861 */    
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 1, 2, 2,    1, 2, 2, 3, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 4, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 3, 2, 1,    1, 2, 1, 2, 2, 1,
	2, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 5, 2, 1,
	
	/* 1871 */    
	2, 2, 1, 2, 2, 1,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 4,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 5, 1,    2, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 4, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 1, 2,
	
	/* 1881 */    
	1, 2, 1, 2, 1, 2,    5, 2, 2, 1, 2, 1,
	1, 2, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 3, 2,    1, 2, 2, 1, 2, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 5, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 5, 2, 1, 2, 2,    1, 2, 1, 2, 1, 2,
	
	/* 1891 */     
	1, 2, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 5,    2, 2, 1, 2, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 5, 1,    2, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 5, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 5, 2, 2, 1, 2,
	
	/* 1901 */    
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 3, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 4, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 5, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	
	/* 1911 */    
	2, 1, 2, 1, 1, 5,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 5, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 3, 2, 1, 2, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    5, 2, 2, 1, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	
	/* 1921 */     
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 2, 2, 3, 2,    1, 1, 2, 1, 2, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 1, 2, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 5, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 5, 1, 2, 1, 1,    2, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 1, 1, 5,    1, 2, 1, 2, 2, 1,
	
	/* 1931 */   
	2, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 6, 1,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 4, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 2, 1,    4, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	
	/* 1941 */    
	2, 2, 1, 2, 2, 4,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 4, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 1, 2,
	2, 5, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    3, 2, 1, 2, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	
	/* 1951 */    
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 4, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 1, 2, 2,
	2, 1, 4, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 5, 2, 1, 2, 2,
	1, 2, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 5,    2, 1, 2, 1, 2, 1,
	
	/* 1961 */    
	2, 1, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 2, 3, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 5, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    5, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	
	/* 1971 */    
	1, 2, 1, 1, 5, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 2, 1,
	2, 2, 1, 5, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 5, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 1,
	2, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 6,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	
	/* 1981 */     
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 3, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 2, 2, 1, 1,    2, 1, 1, 5, 2, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 2, 1, 5,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 2, 1, 1, 5, 1,    2, 1, 2, 2, 2, 2,
	
	/* 1991 */    
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	1, 2, 5, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 2,    1, 5, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 3, 2,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 1,
	
	/* 2001 */    
	2, 2, 2, 3, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 1, 2, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 5, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 2, 1, 1,
	2, 1, 2, 1, 2, 1,    5, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 5, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	
	/* 2011 */   
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 6, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    1, 2, 5, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 2, 1, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 2, 1, 2, 3, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 1, 2, 5, 2, 1,    1, 2, 1, 2, 1, 2,
	
	/* 2021 */    
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 2,    1, 2, 1, 2, 1, 2,
	1, 5, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 2, 1, 1, 5,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 2,
	1, 2, 2, 1, 5, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 1, 2, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	
	/* 2031 */   
	2, 1, 5, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 5, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 4,    1, 1, 2, 1, 2, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 2, 1, 1, 2, 1,
	2, 2, 1, 2, 5, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 2, 1, 
	
	/* 2041 */     
	2, 1, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 5, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2, 
};

static int _info_month[12] =
{
	31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};	

@implementation KLCalendarModel

- (id)init
{
    if (![super init])
        return nil;
    
    _calendarInfo = [[THCalendarInfo alloc] init];
    [_calendarInfo setDate:[NSDate date]];
	
	   
    _cal = CFCalendarCopyCurrent();
    
    _dayNames = [[NSArray alloc] initWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토", nil];
	
	_info_gan = [[NSArray alloc] initWithObjects:@"갑",@"을",@"병",@"정",@"무",@"기",@"경",@"신",@"임",@"계", nil];

	_info_gan2 = [[NSArray alloc] initWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
		
	_info_gee = [[NSArray alloc] initWithObjects:@"자",@"축",@"인",@"묘",@"진",@"사",@"오",@"미",@"신",@"유",@"술",@"해", nil];
	
	_info_gee2 = [[NSArray alloc] initWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"米",@"申",@"酉",@"戌",@"亥", nil];
	
	_info_ddi = [[NSArray alloc] initWithObjects:@"쥐",@"소",@"범",@"토끼",@"용",@"뱀",@"말",@"양",@"원숭이",@"닭",@"개",@"돼지", nil];
	
	_info_week = [[NSArray alloc] initWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토", nil];
	
	_info_week2 = [[NSArray alloc] initWithObjects:@"日",@"月",@"火",@"水",@"木",@"金",@"土", nil];
	
    return self;
}



#pragma mark Public methods

- (void)decrementMonth
{
    [_calendarInfo moveToPreviousMonth];
}

- (void)incrementMonth
{
    [_calendarInfo moveToNextMonth];
}

- (void)decrementYear
{
    [_calendarInfo moveToPreviousYear];
}

- (void)incrementYear
{
    [_calendarInfo moveToNextYear];
}

- (NSString *)selectedMonthName
{
    return [_calendarInfo monthName];
}

- (NSInteger)selectedYear
{
    return [_calendarInfo year];
}

- (NSInteger)selectedMonthNumberOfWeeks
{
    return (NSInteger)[_calendarInfo weeksInMonth];

}

- (void) febdays:(NSInteger) y
{
	_info_month[1] = 28;
	
	if(y%4 == 0)
	{
		if(y%100 == 0 && y%400 == 0)
			return;
	}
	else
		return;
	
	_info_month[1] = 29;
}


- (MCLunarDate *) sol2lunYear:(NSInteger) Year Month:(NSInteger) Month Day:(NSInteger) Day
/* 양력을 음력으로 변환 */
{
	if(Year < 1841 || 2043 < Year)
	{
		return nil;
	}

	/*
	if(Month < 1 || 12 < Month)
	{
		cerr << "1 ~ 12 사이값을입력하세요." << endl;
		return FALSE;
	}
	*/

	[self febdays:Year];
	
	/*
	if(Day < 1 || _info_month[Month-1] < Day)
	{
		cerr << "1 ~ " << _info_month[Month-1] << " 사이값을입력하세요." << endl;
		return FALSE;
	}
	*/

	NSInteger ly, lm, ld;
	NSInteger m1, m2, mm, i, j, w;
	NSInteger sy = Year, sm = Month, sd = Day;
	long td, td1, td2;
	int dt[203], k1, k2;
	BOOL Yoon = NO;

	td1 = 1840 * 365L + 1840/4 - 1840/100 + 1840/400 + 23;
	td2 = (sy-1) * 365L + (sy-1)/4 - (sy-1)/100 + (sy-1)/400 + sd;

	
	for(i=0; i<sm-1; i++)
		td2 += _info_month[i];
	
	td = td2 - td1 + 1;

	for(i=0; i<=sy-1841; i++)
	{
		dt[i] = 0;
		for(j=0; j<12; j++)
		{
			switch( _info_array[i][j] )
			{
				case 1 : mm = 29;
					break;
				case 2 : mm = 30;
					break;
				case 3 : mm = 58;   //29+29
					break;
                case 4 : mm = 59;   // 29+30 
					break;
                case 5 : mm = 59;   // 30+29 
					break;
				case 6 : mm = 60;   // 30+30 
					break;
			}
			dt[i] += mm;
		}
	}
	ly = 0;     

	while(1)
	{
		if( td > dt[ly] )
		{
			td -= dt[ly];
			ly++;
		}
		else
			break;
	}
	lm = 0;

	while(1)
	{
		if( _info_array[ly][lm] <= 2 )
		{
			mm = _info_array[ly][lm] + 28;
			if( td > mm )
			{
				td -= mm;
				lm++;
			}
			else
				break;
		}
		else
		{
			switch( _info_array[ly][lm] )
			{
				case 3 : m1 = 29;
					m2 = 29;
					break;                                
				case 4 : m1 = 29;
					m2 = 30;
					break;
				case 5 : m1 = 30;
					m2 = 29;
					break;
				case 6 : m1 = 30;
					m2 = 30;
					break;
			}
			
			if( td > m1 )
			{
				td -= m1;
				if( td > m2 )
				{
					td -= m2;
					lm++;
				}
				else
				{
					Yoon = TRUE;
					break;
				}
			}
			else
				break;
		}
	}

	ly += 1841;
	lm += 1;
	ld = (Year%400==0 || Year%100!=0 || Year%4==0) ? td : td -1;
	w = td2 % 7;
	i = (td2+4) % 10;
	j = (td2+2) % 12;
	m1 = (lm+3) % 10;
	m2 = (lm+1) % 12;
	k1 = (ly+6) % 10;
	k2 = (ly+8) % 12;


	MCLunarDate *lunarDate = [[[MCLunarDate alloc] init] autorelease];
//	NSLog([NSString stringWithFormat:@"KLCalendarModel : 띠 = %@, %d", [_info_ddi objectAtIndex:k2], k2]);
	lunarDate.currentYearDdi = [_info_ddi objectAtIndex:k2];
	lunarDate.dayOfWeek = [_info_week objectAtIndex:w];
	lunarDate.dayOfWeekGapja = [NSString stringWithFormat:@"%@%@",[_info_gan objectAtIndex:i], [_info_gee objectAtIndex:j]];
	lunarDate.monthOfYearGapja = [NSString stringWithFormat:@"%@%@",[_info_gan objectAtIndex:m1], [_info_gee objectAtIndex:m2]];
	lunarDate.currentYearGapja = [NSString stringWithFormat:@"%@%@",[_info_gan objectAtIndex:k1], [_info_gee objectAtIndex:k2]];
	lunarDate.dayOfWeekChinese = [_info_week2 objectAtIndex:w];
	lunarDate.dayOfWeekGapjaChinese = [NSString stringWithFormat:@"%@%@",[_info_gan2 objectAtIndex:i], [_info_gee2 objectAtIndex:j]];
	lunarDate.currentYearGapjaChinese = [NSString stringWithFormat:@"%@%@",[_info_gan2 objectAtIndex:k1], [_info_gee2 objectAtIndex:k2]];
	lunarDate.monthOfYearGapjaChinese = [NSString stringWithFormat:@"%@%@",[_info_gan2 objectAtIndex:m1], [_info_gee2 objectAtIndex:m2]];
	
	lunarDate.lunarDay = ld;
	lunarDate.yoondal = Yoon ? YES : NO;
	lunarDate.lunarMonth = lm;
	lunarDate.yearDangi = sy+2333;
	lunarDate.yearLunar = ly;
	lunarDate.lunarDayOfWeek = w;
	
	
//	NSLog([NSString stringWithFormat:@"sol2lunYear - retainCount = %d", [lunarDate retainCount]]);
	return lunarDate;
}
	
- (MCSolarDate *) lun2solYear:(NSInteger) Year Month:(NSInteger) Month Day:(NSInteger) Day Leaf:(BOOL)Leaf
	/* 음력을 양력으로 변환 */
	{
		MCSolarDate *solar = [[MCSolarDate alloc] init];
		if(Year < 1841 || 2043 < Year)
		{
			return;
		}
/*		
		if(Month < 1 || 12 < Month)
		{
			cerr << "1 ~ 12 사이값을입력하세요." << endl;
			return FALSE;
		}
*/		
		NSInteger lyear, lmonth, lday, leapyes;
		NSInteger syear, smonth, sday;
		NSInteger mm, y1, y2, m1;
		NSInteger i, j, k1, k2, leap, w;
		long td, y;
		lyear = Year;
		lmonth = Month;
		y1 = lyear - 1841;
		m1 = lmonth - 1;
		leapyes = 0;
		
		
		if( _info_array[y1][m1] > 2)
			leapyes = Leaf;
		
		if( leapyes == 1)
		{
			switch( _info_array[y1][m1] )
			{
				case 3 :
				case 5 :
					mm = 29;
					break;
				case 4 :
				case 6 :
					mm = 30;
					break;
			}
		}
		else
		{
			switch( _info_array[y1][m1] )
			{
				case 1 :
                case 3 :
                case 4 :
					mm = 29;
					break;
				case 2 :
				case 5 :
				case 6 :
					mm = 30;
					break;
			}
		}
/*	
		if(Day < 1 || mm < Day)
		{
			cerr << "1 ~ " << mm << " 사이값을입력하세요." << endl;
			return FALSE;
		}
*/		
		lday = Day;
		td = 0;
		for(i=0; i<y1; i++)
		{
			for(j=0; j<12; j++)
			{
				switch( _info_array[i][j] )
				{
					case 1 :
						td += 29;
						break;
					case 2 :
						td += 30;
						break;
					case 3 :
						td += 58;   // 29+29
						break;
					case 4 :
						td += 59;   // 29+30
						break;
					case 5 :
						td += 59;   // 30+29
						break;
					case 6 :
						td += 60;   // 30+30
						break;
				}
			}
		}
			
		for (j=0; j<m1; j++)
		{
			switch( _info_array[y1][j] )
			{
				case 1 :
					td +=29;
					break;
				case 2 :
					td += 30;
					break;
				case 3 :
					td += 58;   // 29+29
					break;
				case 4 :
					td += 59;   // 29+30
					break;
				case 5 :
					td += 59;   // 30+29
					break;
				case 6 :
					td += 60;   // 30+30
					break;
			}
		}
		
		if( leapyes == 1 )
		{
			switch( _info_array[y1][m1] )
			{
				case 3 :
				case 4 :
					td += 29;
					break;
				case 5 :
				case 6 :
					td += 30;
					break;
			}
		}
		td += lday + 22;
		// td : 1841년1월1일부터원하는날까지의전체날수의합
		
		y1 = 1840;
		do {
			y1++;
			leap = (y1 % 400 == 0) || (y1 % 100 != 0) && (y1 % 4 ==0);
			if(leap)
				y2 = 366;
			else    
				y2 = 365;
			if(td <= y2)
				break;
			td -= y2;
		} while(1);
		
		syear = y1;
		_info_month[1] = y2 - 337;
		m1 = 0;
		do
		{
			m1++;
			if( td <= _info_month[m1-1] )
				break;
			td -= _info_month[m1-1];
		} while(1);
		
		smonth = m1;
		sday = td;
		y = syear - 1;
		td = y * 365L + y/4 - y/100 + y/400;
		for(i=0; i<smonth-1; i++) td += _info_month[i];
		td += sday;
		w = td % 7;
		
		i = (td + 4) % 10;
		j = (td + 2) % 12;
		k1 = (lyear + 6) % 10;
		k2 = (lyear + 8) % 12;

		
		solar.year = syear;
		solar.month = smonth;
		solar.day = sday;
		solar.dayofweek = w;
		
		return solar;
}
					
// gives you "Mon" for input 1 if region is set to United States ("Mon" for Monday)
// if region uses a calendar that starts the week with monday, an input of 1 will give "Tue"
- (NSString *)dayNameAbbreviationForDayOfWeek:(NSUInteger)dayOfWeek
{
    if (CFCalendarGetFirstWeekday(_cal) == 2)          // Monday is first day of week
        return [_dayNames objectAtIndex:(dayOfWeek+1)%7];
    
    return [_dayNames objectAtIndex:dayOfWeek];        // Sunday is first day of week
}

- (NSArray *)daysInFinalWeekOfPreviousMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];

    [_calendarInfo moveToFirstDayOfMonth];
    [_calendarInfo moveToPreviousDay];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger lastDayOfPreviousMonth = [_calendarInfo dayOfMonth];
    NSInteger lastDayOfWeekInPreviousMonth = [_calendarInfo dayOfWeek];
    
    if (lastDayOfWeekInPreviousMonth != 7)
        for (NSInteger day = 1 + lastDayOfPreviousMonth - lastDayOfWeekInPreviousMonth; day <= lastDayOfPreviousMonth; day++) {
            KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
            [days addObject:d];
            [d release];
        }

        
    [_calendarInfo setDate:savedState];
    return days;
}

- (NSArray *)daysInSelectedMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger lastDayOfMonth = [_calendarInfo daysInMonth];
    
    for (NSInteger day = 1; day <= lastDayOfMonth; day++) {
        KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
        [days addObject:d];
        [d release];
    }
    
    [_calendarInfo setDate:savedState];
    
    return days;
}

- (NSArray *)daysInFirstWeekOfFollowingMonth
{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    [_calendarInfo moveToNextMonth];
    [_calendarInfo moveToFirstDayOfMonth];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger firstDayOfWeekInFollowingMonth = [_calendarInfo dayOfWeek];
    
    if (firstDayOfWeekInFollowingMonth != 1)
        for (NSInteger day = 1; day <= 8-firstDayOfWeekInFollowingMonth; day++) {
            KLDate *d = [[KLDate alloc] initWithYear:year month:month day:day];
            [days addObject:d];
            [d release];
        }
    
    [_calendarInfo setDate:savedState];
    return days;
}

- (void)dealloc
{
    CFRelease(_cal);
    [_calendarInfo release];
    [_dayNames release];

	[_info_gan release];
	[_info_gan2 release];
	[_info_gee release];
	[_info_gee2 release];
	[_info_ddi release];
	[_info_week release];
	[_info_week2 release];
    [super dealloc];
}

@end





