//
//  ACEModeNames.m
//  ACEView
//
//  Created by Michael Robinson on 2/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import "ACEModeNames.h"

NSString *const _ACEModeNames[ACEModeCount] = {
    [ACEModeASCIIDoc]			 = @"asciidoc",
    [ACEModeC9Search]			 = @"c9search",
    [ACEModeCPP]				 = @"c_cpp",
    [ACEModeClojure]			 = @"clojure",
    [ACEModeCoffee]              = @"coffee",
    [ACEModeColdfusion]			 = @"coldfusion",
    [ACEModeCSharp]				 = @"csharp",
    [ACEModeCSS]				 = @"css",
    [ACEModeDiff]				 = @"diff",
    [ACEModeGLSL]				 = @"glsl",
    [ACEModeGolang]				 = @"golang",
    [ACEModeGroovy]				 = @"groovy",
    [ACEModeHaxe]				 = @"haxe",
    [ACEModeHTML]				 = @"html",
    [ACEModeJade]				 = @"jade",
    [ACEModeJava]				 = @"java",
    [ACEModeJavaScript]			 = @"javascript",
    [ACEModeJSON]				 = @"json",
    [ACEModeJSP]				 = @"jsp",
    [ACEModeJSX]				 = @"jsx",
    [ACEModeLatex]				 = @"latex",
    [ACEModeLESS]				 = @"less",
    [ACEModeLiquid]				 = @"liquid",
    [ACEModeLua]				 = @"lua",
    [ACEModeLuapage]			 = @"luapage",
    [ACEModeMarkdown]			 = @"markdown",
    [ACEModeOCaml]				 = @"ocaml",
    [ACEModePerl]				 = @"perl",
    [ACEModePGSQL]				 = @"pgsql",
    [ACEModePHP]				 = @"php",
    [ACEModePowershell]			 = @"powershell",
    [ACEModePython]				 = @"python",
    [ACEModeRuby]				 = @"ruby",
    [ACEModeSCAD]				 = @"scad",
    [ACEModeScala]				 = @"scala",
    [ACEModeSCSS]				 = @"scss",
    [ACEModeSH]                  = @"sh",
    [ACEModeSQL]				 = @"sql",
    [ACEModeSVG]				 = @"svg",
    [ACEModeTcl]				 = @"tcl",
    [ACEModeText]				 = @"text",
    [ACEModeTextile]             = @"textile",
    [ACEModeTypescript]			 = @"typescript",
    [ACEModeXML]				 = @"xml",
    [ACEModeXQuery]				 = @"xquery",
    [ACEModeYAML]				 = @"yaml"
};

NSString *const _ACEModeNamesHuman[ACEModeCount] = {
    [ACEModeASCIIDoc]			 = @"ASCII Doc",
    [ACEModeC9Search]			 = @"C9 Search",
    [ACEModeCPP]				 = @"C++",
    [ACEModeClojure]			 = @"Clojure",
    [ACEModeCoffee]              = @"Coffee",
    [ACEModeColdfusion]			 = @"ColdFusion",
    [ACEModeCSharp]				 = @"C#",
    [ACEModeCSS]				 = @"CSS",
    [ACEModeDiff]				 = @"Diff",
    [ACEModeGLSL]				 = @"GLSL",
    [ACEModeGolang]				 = @"Go",
    [ACEModeGroovy]				 = @"Groovy",
    [ACEModeHaxe]				 = @"Haxe",
    [ACEModeHTML]				 = @"HTML",
    [ACEModeJade]				 = @"Jade",
    [ACEModeJava]				 = @"Java",
    [ACEModeJavaScript]			 = @"JavaScript",
    [ACEModeJSON]				 = @"JSON",
    [ACEModeJSP]				 = @"JSP",
    [ACEModeJSX]				 = @"JSX",
    [ACEModeLatex]				 = @"Latex",
    [ACEModeLESS]				 = @"LESS",
    [ACEModeLiquid]				 = @"Liquid",
    [ACEModeLua]				 = @"Lua",
    [ACEModeLuapage]			 = @"Luapage",
    [ACEModeMarkdown]			 = @"Markdown",
    [ACEModeOCaml]				 = @"OCaml",
    [ACEModePerl]				 = @"Perl",
    [ACEModePGSQL]				 = @"PGSQL",
    [ACEModePHP]				 = @"PHP",
    [ACEModePowershell]			 = @"Powershell",
    [ACEModePython]				 = @"Python",
    [ACEModeRuby]				 = @"Ruby",
    [ACEModeSCAD]				 = @"SCAD",
    [ACEModeScala]				 = @"Ccala",
    [ACEModeSCSS]				 = @"SCSS",
    [ACEModeSH]                  = @"SH",
    [ACEModeSQL]				 = @"SQL",
    [ACEModeSVG]				 = @"SVG",
    [ACEModeTcl]				 = @"Tcl",
    [ACEModeText]				 = @"Text",
    [ACEModeTextile]             = @"Textile",
    [ACEModeTypescript]			 = @"Typescript",
    [ACEModeXML]				 = @"XML",
    [ACEModeXQuery]				 = @"XQuery",
    [ACEModeYAML]				 = @"YAML"
};

@implementation ACEModeNames

+ (NSArray *) modeNames {
    return [NSArray arrayWithObjects:_ACEModeNames count:ACEModeCount];
}
+ (NSArray *) humanModeNames {
    return [NSArray arrayWithObjects:_ACEModeNamesHuman count:ACEModeCount];
}

+ (NSString *) nameForMode:(ACEMode)mode  {
    return _ACEModeNames[mode];
}
+ (NSString *) humanNameForMode:(ACEMode)mode {
    return _ACEModeNamesHuman[mode];
}

@end
