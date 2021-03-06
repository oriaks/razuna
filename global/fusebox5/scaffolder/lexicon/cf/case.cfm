<cfscript>
	// example custom verb that compiles to a <cfcase> tag
	// usage:
	// 1. add the lexicon declaration to your circuit file:
	//    <circuit xmlns:cf="cf/">
	// 2. use the verb in a fuseaction:
	//    <cf:switch expression="#someExpr#">
	//    <cf:case value="someValue">
	//        ... some code ...
	//    </cf:catch>
	//    <cf:case value="anotherValue|andAnother" delimiters="|">
	//        ... more code ...
	//    </cf:case>
	//    <cf:defaultcase>
	//        ... default code ...
	//    </cf:defaultcase>
	//    </cf:switch>
	//
	// how this works:
	// a. validate the attributes passed in (fb_.verbInfo.attributes)
	// b. in start mode, generate the required CFML
	// c. in end mode, generate the required CFML
	//
	if (fb_.verbInfo.executionMode is "start") {
		//
		// validate attributes:
		// parent tag must be a switch verb in the same lexicon:
		if (not structKeyExists(fb_.verbInfo,"parent") or
				fb_.verbInfo.parent.lexicon is not fb_.verbInfo.lexicon or
				fb_.verbInfo.parent.lexiconVerb is not "switch") {
			fb_throw("fusebox.badGrammar.invalidNesting",
						"Verb is invalid in this context",
						"The verb 'case' does not appear directly nested within a 'switch' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
		}
		//
		// value is required:
		if (not structKeyExists(fb_.verbInfo.attributes,"value")) {
			fb_throw("fusebox.badGrammar.requiredAttributeMissing",
						"Required attribute is missing",
						"The attribute 'value' is required, for a 'case' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
		}
		//
		// delimiters is optional:
		if (structKeyExists(fb_.verbInfo.attributes,"delimiters")) {
			fb_.delimiters = ' delimiters="#fb_.verbInfo.attributes.delimiters#"';
		} else {
			fb_.delimiters = '';
		}
		//
		// start mode:
		fb_appendLine('<' & 'cfcase value="#fb_.verbInfo.attributes.value#"#fb_.delimiters#>');
	} else {
		//
		// end mode:
		fb_appendLine('<' & '/cfcase>');
	}
</cfscript>
