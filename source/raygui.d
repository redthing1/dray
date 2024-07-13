/*******************************************************************************************
*
*   raygui v4.0 - A simple and easy-to-use immediate-mode gui library
*
*   DESCRIPTION:
*       raygui is a tools-dev-focused immediate-mode-gui library based on raylib but also
*       available as a standalone library, as long as input and drawing functions are provided.
*
*   FEATURES:
*       - Immediate-mode gui, minimal retained data
*       - +25 controls provided (basic and advanced)
*       - Styling system for colors, font and metrics
*       - Icons supported, embedded as a 1-bit icons pack
*       - Standalone mode option (custom input/graphics backend)
*       - Multiple support tools provided for raygui development
*
*   POSSIBLE IMPROVEMENTS:
*       - Better standalone mode API for easy plug of custom backends
*       - Externalize required inputs, allow user easier customization
*
*   LIMITATIONS:
*       - No editable multi-line word-wraped text box supported
*       - No auto-layout mechanism, up to the user to define controls position and size
*       - Standalone mode requires library modification and some user work to plug another backend
*
*   NOTES:
*       - WARNING: GuiLoadStyle() and GuiLoadStyle{Custom}() functions, allocate memory for
*         font atlas recs and glyphs, freeing that memory is (usually) up to the user,
*         no unload function is explicitly provided... but note that GuiLoadStyleDefaulf() unloads
*         by default any previously loaded font (texture, recs, glyphs).
*       - Global UI alpha (guiAlpha) is applied inside GuiDrawRectangle() and GuiDrawText() functions
*
*   CONTROLS PROVIDED:
*     # Container/separators Controls
*       - WindowBox     --> StatusBar, Panel
*       - GroupBox      --> Line
*       - Line
*       - Panel         --> StatusBar
*       - ScrollPanel   --> StatusBar
*       - TabBar        --> Button
*
*     # Basic Controls
*       - Label
*       - LabelButton   --> Label
*       - Button
*       - Toggle
*       - ToggleGroup   --> Toggle
*       - ToggleSlider
*       - CheckBox
*       - ComboBox
*       - DropdownBox
*       - TextBox
*       - ValueBox      --> TextBox
*       - Spinner       --> Button, ValueBox
*       - Slider
*       - SliderBar     --> Slider
*       - ProgressBar
*       - StatusBar
*       - DummyRec
*       - Grid
*
*     # Advance Controls
*       - ListView
*       - ColorPicker   --> ColorPanel, ColorBarHue
*       - MessageBox    --> Window, Label, Button
*       - TextInputBox  --> Window, Label, TextBox, Button
*
*     It also provides a set of functions for styling the controls based on its properties (size, color).
*
*
*   RAYGUI STYLE (guiStyle):
*       raygui uses a global data array for all gui style properties (allocated on data segment by default),
*       when a new style is loaded, it is loaded over the global style... but a default gui style could always be
*       recovered with GuiLoadStyleDefault() function, that overwrites the current style to the default one
*
*       The global style array size is fixed and depends on the number of controls and properties:
*
*           static unsigned int guiStyle[RAYGUI_MAX_CONTROLS*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED)];
*
*       guiStyle size is by default: 16*(16 + 8) = 384*4 = 1536 bytes = 1.5 KB
*
*       Note that the first set of BASE properties (by default guiStyle[0..15]) belong to the generic style
*       used for all controls, when any of those base values is set, it is automatically populated to all
*       controls, so, specific control values overwriting generic style should be set after base values.
*
*       After the first BASE set we have the EXTENDED properties (by default guiStyle[16..23]), those
*       properties are actually common to all controls and can not be overwritten individually (like BASE ones)
*       Some of those properties are: TEXT_SIZE, TEXT_SPACING, LINE_COLOR, BACKGROUND_COLOR
*
*       Custom control properties can be defined using the EXTENDED properties for each independent control.
*
*       TOOL: rGuiStyler is a visual tool to customize raygui style: github.com/raysan5/rguistyler
*
*
*   RAYGUI ICONS (guiIcons):
*       raygui could use a global array containing icons data (allocated on data segment by default),
*       a custom icons set could be loaded over this array using GuiLoadIcons(), but loaded icons set
*       must be same RAYGUI_ICON_SIZE and no more than RAYGUI_ICON_MAX_ICONS will be loaded
*
*       Every icon is codified in binary form, using 1 bit per pixel, so, every 16x16 icon
*       requires 8 integers (16*16/32) to be stored in memory.
*
*       When the icon is draw, actually one quad per pixel is drawn if the bit for that pixel is set.
*
*       The global icons array size is fixed and depends on the number of icons and size:
*
*           static unsigned int guiIcons[RAYGUI_ICON_MAX_ICONS*RAYGUI_ICON_DATA_ELEMENTS];
*
*       guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
*
*       TOOL: rGuiIcons is a visual tool to customize/create raygui icons: github.com/raysan5/rguiicons
*
*   RAYGUI LAYOUT:
*       raygui currently does not provide an auto-layout mechanism like other libraries,
*       layouts must be defined manually on controls drawing, providing the right bounds Rectangle for it.
*
*       TOOL: rGuiLayout is a visual tool to create raygui layouts: github.com/raysan5/rguilayout
*
*   CONFIGURATION:
*       #define RAYGUI_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RAYGUI_STANDALONE
*           Avoid raylib.h header inclusion in this file. Data types defined on raylib are defined
*           internally in the library and input management and drawing functions must be provided by
*           the user (check library implementation for further details).
*
*       #define RAYGUI_NO_ICONS
*           Avoid including embedded ricons data (256 icons, 16x16 pixels, 1-bit per pixel, 2KB)
*
*       #define RAYGUI_CUSTOM_ICONS
*           Includes custom ricons.h header defining a set of custom icons,
*           this file can be generated using rGuiIcons tool
*
*       #define RAYGUI_DEBUG_RECS_BOUNDS
*           Draw control bounds rectangles for debug
*
*       #define RAYGUI_DEBUG_TEXT_BOUNDS
*           Draw text bounds rectangles for debug
*
*   VERSIONS HISTORY:
*       4.0 (12-Sep-2023) ADDED: GuiToggleSlider()
*                         ADDED: GuiColorPickerHSV() and GuiColorPanelHSV()
*                         ADDED: Multiple new icons, mostly compiler related
*                         ADDED: New DEFAULT properties: TEXT_LINE_SPACING, TEXT_ALIGNMENT_VERTICAL, TEXT_WRAP_MODE
*                         ADDED: New enum values: GuiTextAlignment, GuiTextAlignmentVertical, GuiTextWrapMode
*                         ADDED: Support loading styles with custom font charset from external file
*                         REDESIGNED: GuiTextBox(), support mouse cursor positioning
*                         REDESIGNED: GuiDrawText(), support multiline and word-wrap modes (read only)
*                         REDESIGNED: GuiProgressBar() to be more visual, progress affects border color
*                         REDESIGNED: Global alpha consideration moved to GuiDrawRectangle() and GuiDrawText()
*                         REDESIGNED: GuiScrollPanel(), get parameters by reference and return result value
*                         REDESIGNED: GuiToggleGroup(), get parameters by reference and return result value
*                         REDESIGNED: GuiComboBox(), get parameters by reference and return result value
*                         REDESIGNED: GuiCheckBox(), get parameters by reference and return result value
*                         REDESIGNED: GuiSlider(), get parameters by reference and return result value
*                         REDESIGNED: GuiSliderBar(), get parameters by reference and return result value
*                         REDESIGNED: GuiProgressBar(), get parameters by reference and return result value
*                         REDESIGNED: GuiListView(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorPicker(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorPanel(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorBarAlpha(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorBarHue(), get parameters by reference and return result value
*                         REDESIGNED: GuiGrid(), get parameters by reference and return result value
*                         REDESIGNED: GuiGrid(), added extra parameter
*                         REDESIGNED: GuiListViewEx(), change parameters order
*                         REDESIGNED: All controls return result as int value
*                         REVIEWED: GuiScrollPanel() to avoid smallish scroll-bars
*                         REVIEWED: All examples and specially controls_test_suite
*                         RENAMED: gui_file_dialog module to gui_window_file_dialog
*                         UPDATED: All styles to include ISO-8859-15 charset (as much as possible)
*
*       3.6 (10-May-2023) ADDED: New icon: SAND_TIMER
*                         ADDED: GuiLoadStyleFromMemory() (binary only)
*                         REVIEWED: GuiScrollBar() horizontal movement key
*                         REVIEWED: GuiTextBox() crash on cursor movement
*                         REVIEWED: GuiTextBox(), additional inputs support
*                         REVIEWED: GuiLabelButton(), avoid text cut
*                         REVIEWED: GuiTextInputBox(), password input
*                         REVIEWED: Local GetCodepointNext(), aligned with raylib
*                         REDESIGNED: GuiSlider*()/GuiScrollBar() to support out-of-bounds
*
*       3.5 (20-Apr-2023) ADDED: GuiTabBar(), based on GuiToggle()
*                         ADDED: Helper functions to split text in separate lines
*                         ADDED: Multiple new icons, useful for code editing tools
*                         REMOVED: Unneeded icon editing functions
*                         REMOVED: GuiTextBoxMulti(), very limited and broken
*                         REMOVED: MeasureTextEx() dependency, logic directly implemented
*                         REMOVED: DrawTextEx() dependency, logic directly implemented
*                         REVIEWED: GuiScrollBar(), improve mouse-click behaviour
*                         REVIEWED: Library header info, more info, better organized
*                         REDESIGNED: GuiTextBox() to support cursor movement
*                         REDESIGNED: GuiDrawText() to divide drawing by lines
*
*       3.2 (22-May-2022) RENAMED: Some enum values, for unification, avoiding prefixes
*                         REMOVED: GuiScrollBar(), only internal
*                         REDESIGNED: GuiPanel() to support text parameter
*                         REDESIGNED: GuiScrollPanel() to support text parameter
*                         REDESIGNED: GuiColorPicker() to support text parameter
*                         REDESIGNED: GuiColorPanel() to support text parameter
*                         REDESIGNED: GuiColorBarAlpha() to support text parameter
*                         REDESIGNED: GuiColorBarHue() to support text parameter
*                         REDESIGNED: GuiTextInputBox() to support password
*
*       3.1 (12-Jan-2022) REVIEWED: Default style for consistency (aligned with rGuiLayout v2.5 tool)
*                         REVIEWED: GuiLoadStyle() to support compressed font atlas image data and unload previous textures
*                         REVIEWED: External icons usage logic
*                         REVIEWED: GuiLine() for centered alignment when including text
*                         RENAMED: Multiple controls properties definitions to prepend RAYGUI_
*                         RENAMED: RICON_ references to RAYGUI_ICON_ for library consistency
*                         Projects updated and multiple tweaks
*
*       3.0 (04-Nov-2021) Integrated ricons data to avoid external file
*                         REDESIGNED: GuiTextBoxMulti()
*                         REMOVED: GuiImageButton*()
*                         Multiple minor tweaks and bugs corrected
*
*       2.9 (17-Mar-2021) REMOVED: Tooltip API
*       2.8 (03-May-2020) Centralized rectangles drawing to GuiDrawRectangle()
*       2.7 (20-Feb-2020) ADDED: Possible tooltips API
*       2.6 (09-Sep-2019) ADDED: GuiTextInputBox()
*                         REDESIGNED: GuiListView*(), GuiDropdownBox(), GuiSlider*(), GuiProgressBar(), GuiMessageBox()
*                         REVIEWED: GuiTextBox(), GuiSpinner(), GuiValueBox(), GuiLoadStyle()
*                         Replaced property INNER_PADDING by TEXT_PADDING, renamed some properties
*                         ADDED: 8 new custom styles ready to use
*                         Multiple minor tweaks and bugs corrected
*
*       2.5 (28-May-2019) Implemented extended GuiTextBox(), GuiValueBox(), GuiSpinner()
*       2.3 (29-Apr-2019) ADDED: rIcons auxiliar library and support for it, multiple controls reviewed
*                         Refactor all controls drawing mechanism to use control state
*       2.2 (05-Feb-2019) ADDED: GuiScrollBar(), GuiScrollPanel(), reviewed GuiListView(), removed Gui*Ex() controls
*       2.1 (26-Dec-2018) REDESIGNED: GuiCheckBox(), GuiComboBox(), GuiDropdownBox(), GuiToggleGroup() > Use combined text string
*                         REDESIGNED: Style system (breaking change)
*       2.0 (08-Nov-2018) ADDED: Support controls guiLock and custom fonts
*                         REVIEWED: GuiComboBox(), GuiListView()...
*       1.9 (09-Oct-2018) REVIEWED: GuiGrid(), GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()...
*       1.8 (01-May-2018) Lot of rework and redesign to align with rGuiStyler and rGuiLayout
*       1.5 (21-Jun-2017) Working in an improved styles system
*       1.4 (15-Jun-2017) Rewritten all GUI functions (removed useless ones)
*       1.3 (12-Jun-2017) Complete redesign of style system
*       1.1 (01-Jun-2017) Complete review of the library
*       1.0 (07-Jun-2016) Converted to header-only by Ramon Santamaria.
*       0.9 (07-Mar-2016) Reviewed and tested by Albert Martos, Ian Eito, Sergio Martinez and Ramon Santamaria.
*       0.8 (27-Aug-2015) Initial release. Implemented by Kevin Gato, Daniel Nicolás and Ramon Santamaria.
*
*   DEPENDENCIES:
*       raylib 4.6-dev      Inputs reading (keyboard/mouse), shapes drawing, font loading and text drawing
*
*   STANDALONE MODE:
*       By default raygui depends on raylib mostly for the inputs and the drawing functionality but that dependency can be disabled
*       with the config flag RAYGUI_STANDALONE. In that case is up to the user to provide another backend to cover library needs.
*
*       The following functions should be redefined for a custom backend:
*
*           - Vector2 GetMousePosition(void);
*           - float GetMouseWheelMove(void);
*           - bool IsMouseButtonDown(int button);
*           - bool IsMouseButtonPressed(int button);
*           - bool IsMouseButtonReleased(int button);
*           - bool IsKeyDown(int key);
*           - bool IsKeyPressed(int key);
*           - int GetCharPressed(void);         // -- GuiTextBox(), GuiValueBox()
*
*           - void DrawRectangle(int x, int y, int width, int height, Color color); // -- GuiDrawRectangle()
*           - void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4); // -- GuiColorPicker()
*
*           - Font GetFontDefault(void);                            // -- GuiLoadStyleDefault()
*           - Font LoadFontEx(const char *fileName, int fontSize, int *codepoints, int codepointCount); // -- GuiLoadStyle()
*           - Texture2D LoadTextureFromImage(Image image);          // -- GuiLoadStyle(), required to load texture from embedded font atlas image
*           - void SetShapesTexture(Texture2D tex, Rectangle rec);  // -- GuiLoadStyle(), required to set shapes rec to font white rec (optimization)
*           - char *LoadFileText(const char *fileName);             // -- GuiLoadStyle(), required to load charset data
*           - void UnloadFileText(char *text);                      // -- GuiLoadStyle(), required to unload charset data
*           - const char *GetDirectoryPath(const char *filePath);   // -- GuiLoadStyle(), required to find charset/font file from text .rgs
*           - int *LoadCodepoints(const char *text, int *count);    // -- GuiLoadStyle(), required to load required font codepoints list
*           - void UnloadCodepoints(int *codepoints);               // -- GuiLoadStyle(), required to unload codepoints list
*           - unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize); // -- GuiLoadStyle()
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, redesign, update and maintenance
*       Vlad Adrian:        Complete rewrite of GuiTextBox() to support extended features (2019)
*       Sergio Martinez:    Review, testing (2015) and redesign of multiple controls (2018)
*       Adria Arranz:       Testing and implementation of additional controls (2018)
*       Jordi Jorba:        Testing and implementation of additional controls (2018)
*       Albert Martos:      Review and testing of the library (2015)
*       Ian Eito:           Review and testing of the library (2015)
*       Kevin Gato:         Initial implementation of basic components (2014)
*       Daniel Nicolas:     Initial implementation of basic components (2014)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
**********************************************************************************************/

import raylib;

extern (C) @nogc nothrow:

enum RAYGUI_VERSION_MAJOR = 4;
enum RAYGUI_VERSION_MINOR = 0;
enum RAYGUI_VERSION_PATCH = 0;
enum RAYGUI_VERSION = "4.0";

// Function specifiers in case library is build/used as a shared library (Windows)
// NOTE: Microsoft specifiers to tell compiler that symbols are imported/exported from a .dll

// We are building the library as a Win32 shared library (.dll)

// We are using the library as a Win32 shared library (.dll)

// Function specifiers definition // Functions defined as 'extern' by default (implicit specifiers)

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------
// // Allow custom memory allocators

// alias RAYGUI_MALLOC = malloc;

// alias RAYGUI_CALLOC = calloc;

// alias RAYGUI_FREE = free;

// Simple log system to avoid printf() calls if required
// NOTE: Avoiding those calls, also avoids const strings memory usage

//----------------------------------------------------------------------------------
// Types and Structures Definition
// NOTE: Some types are required for RAYGUI_STANDALONE usage
//----------------------------------------------------------------------------------

// Boolean type

// Vector2 type

// Vector3 type                 // -- ConvertHSVtoRGB(), ConvertRGBtoHSV()

// Color type, RGBA (32bit)

// Rectangle type

// TODO: Texture2D type is very coupled to raylib, required by Font type
// It should be redesigned to be provided by user

// OpenGL texture id
// Texture base width
// Texture base height
// Mipmap levels, 1 by default
// Data format (PixelFormat type)

// Image, pixel data stored in CPU memory (RAM)

// Image raw data
// Image base width
// Image base height
// Mipmap levels, 1 by default
// Data format (PixelFormat type)

// GlyphInfo, font characters glyphs info

// Character value (Unicode)
// Character offset X when drawing
// Character offset Y when drawing
// Character advance position X
// Character image data

// TODO: Font type is very coupled to raylib, mostly required by GuiLoadStyle()
// It should be redesigned to be provided by user

// Base size (default chars height)
// Number of glyph characters
// Padding around the glyph characters
// Texture atlas containing the glyphs
// Rectangles in texture for the glyphs
// Glyphs info data

// Style property
// NOTE: Used when exporting style as code for convenience
struct GuiStyleProp
{
    ushort controlId; // Control identifier
    ushort propertyId; // Property identifier
    int propertyValue; // Property value
}

/*
// Controls text style -NOT USED-
// NOTE: Text style is defined by control
typedef struct GuiTextStyle {
    unsigned int size;
    int charSpacing;
    int lineSpacing;
    int alignmentH;
    int alignmentV;
    int padding;
} GuiTextStyle;
*/

// Gui control state
enum GuiState
{
    STATE_NORMAL = 0,
    STATE_FOCUSED = 1,
    STATE_PRESSED = 2,
    STATE_DISABLED = 3
}

alias STATE_NORMAL = GuiState.STATE_NORMAL;
alias STATE_FOCUSED = GuiState.STATE_FOCUSED;
alias STATE_PRESSED = GuiState.STATE_PRESSED;
alias STATE_DISABLED = GuiState.STATE_DISABLED;

// Gui control text alignment
enum GuiTextAlignment
{
    TEXT_ALIGN_LEFT = 0,
    TEXT_ALIGN_CENTER = 1,
    TEXT_ALIGN_RIGHT = 2
}

alias TEXT_ALIGN_LEFT = GuiTextAlignment.TEXT_ALIGN_LEFT;
alias TEXT_ALIGN_CENTER = GuiTextAlignment.TEXT_ALIGN_CENTER;
alias TEXT_ALIGN_RIGHT = GuiTextAlignment.TEXT_ALIGN_RIGHT;

// Gui control text alignment vertical
// NOTE: Text vertical position inside the text bounds
enum GuiTextAlignmentVertical
{
    TEXT_ALIGN_TOP = 0,
    TEXT_ALIGN_MIDDLE = 1,
    TEXT_ALIGN_BOTTOM = 2
}

alias TEXT_ALIGN_TOP = GuiTextAlignmentVertical.TEXT_ALIGN_TOP;
alias TEXT_ALIGN_MIDDLE = GuiTextAlignmentVertical.TEXT_ALIGN_MIDDLE;
alias TEXT_ALIGN_BOTTOM = GuiTextAlignmentVertical.TEXT_ALIGN_BOTTOM;

// Gui control text wrap mode
// NOTE: Useful for multiline text
enum GuiTextWrapMode
{
    TEXT_WRAP_NONE = 0,
    TEXT_WRAP_CHAR = 1,
    TEXT_WRAP_WORD = 2
}

alias TEXT_WRAP_NONE = GuiTextWrapMode.TEXT_WRAP_NONE;
alias TEXT_WRAP_CHAR = GuiTextWrapMode.TEXT_WRAP_CHAR;
alias TEXT_WRAP_WORD = GuiTextWrapMode.TEXT_WRAP_WORD;

// Gui controls
enum GuiControl
{
    // Default -> populates to all controls when set
    DEFAULT = 0,

    // Basic controls
    LABEL = 1, // Used also for: LABELBUTTON
    BUTTON = 2,
    TOGGLE = 3, // Used also for: TOGGLEGROUP
    SLIDER = 4, // Used also for: SLIDERBAR, TOGGLESLIDER
    PROGRESSBAR = 5,
    CHECKBOX = 6,
    COMBOBOX = 7,
    DROPDOWNBOX = 8,
    TEXTBOX = 9, // Used also for: TEXTBOXMULTI
    VALUEBOX = 10,
    SPINNER = 11, // Uses: BUTTON, VALUEBOX
    LISTVIEW = 12,
    COLORPICKER = 13,
    SCROLLBAR = 14,
    STATUSBAR = 15
}

alias DEFAULT = GuiControl.DEFAULT;
alias LABEL = GuiControl.LABEL;
alias BUTTON = GuiControl.BUTTON;
alias TOGGLE = GuiControl.TOGGLE;
alias SLIDER = GuiControl.SLIDER;
alias PROGRESSBAR = GuiControl.PROGRESSBAR;
alias CHECKBOX = GuiControl.CHECKBOX;
alias COMBOBOX = GuiControl.COMBOBOX;
alias DROPDOWNBOX = GuiControl.DROPDOWNBOX;
alias TEXTBOX = GuiControl.TEXTBOX;
alias VALUEBOX = GuiControl.VALUEBOX;
alias SPINNER = GuiControl.SPINNER;
alias LISTVIEW = GuiControl.LISTVIEW;
alias COLORPICKER = GuiControl.COLORPICKER;
alias SCROLLBAR = GuiControl.SCROLLBAR;
alias STATUSBAR = GuiControl.STATUSBAR;

// Gui base properties for every control
// NOTE: RAYGUI_MAX_PROPS_BASE properties (by default 16 properties)
enum GuiControlProperty
{
    BORDER_COLOR_NORMAL = 0, // Control border color in STATE_NORMAL
    BASE_COLOR_NORMAL = 1, // Control base color in STATE_NORMAL
    TEXT_COLOR_NORMAL = 2, // Control text color in STATE_NORMAL
    BORDER_COLOR_FOCUSED = 3, // Control border color in STATE_FOCUSED
    BASE_COLOR_FOCUSED = 4, // Control base color in STATE_FOCUSED
    TEXT_COLOR_FOCUSED = 5, // Control text color in STATE_FOCUSED
    BORDER_COLOR_PRESSED = 6, // Control border color in STATE_PRESSED
    BASE_COLOR_PRESSED = 7, // Control base color in STATE_PRESSED
    TEXT_COLOR_PRESSED = 8, // Control text color in STATE_PRESSED
    BORDER_COLOR_DISABLED = 9, // Control border color in STATE_DISABLED
    BASE_COLOR_DISABLED = 10, // Control base color in STATE_DISABLED
    TEXT_COLOR_DISABLED = 11, // Control text color in STATE_DISABLED
    BORDER_WIDTH = 12, // Control border size, 0 for no border
    //TEXT_SIZE,                  // Control text size (glyphs max height) -> GLOBAL for all controls
    //TEXT_SPACING,               // Control text spacing between glyphs -> GLOBAL for all controls
    //TEXT_LINE_SPACING           // Control text spacing between lines -> GLOBAL for all controls
    TEXT_PADDING = 13, // Control text padding, not considering border
    TEXT_ALIGNMENT = 14 // Control text horizontal alignment inside control text bound (after border and padding)
    //TEXT_WRAP_MODE              // Control text wrap-mode inside text bounds -> GLOBAL for all controls
}

alias BORDER_COLOR_NORMAL = GuiControlProperty.BORDER_COLOR_NORMAL;
alias BASE_COLOR_NORMAL = GuiControlProperty.BASE_COLOR_NORMAL;
alias TEXT_COLOR_NORMAL = GuiControlProperty.TEXT_COLOR_NORMAL;
alias BORDER_COLOR_FOCUSED = GuiControlProperty.BORDER_COLOR_FOCUSED;
alias BASE_COLOR_FOCUSED = GuiControlProperty.BASE_COLOR_FOCUSED;
alias TEXT_COLOR_FOCUSED = GuiControlProperty.TEXT_COLOR_FOCUSED;
alias BORDER_COLOR_PRESSED = GuiControlProperty.BORDER_COLOR_PRESSED;
alias BASE_COLOR_PRESSED = GuiControlProperty.BASE_COLOR_PRESSED;
alias TEXT_COLOR_PRESSED = GuiControlProperty.TEXT_COLOR_PRESSED;
alias BORDER_COLOR_DISABLED = GuiControlProperty.BORDER_COLOR_DISABLED;
alias BASE_COLOR_DISABLED = GuiControlProperty.BASE_COLOR_DISABLED;
alias TEXT_COLOR_DISABLED = GuiControlProperty.TEXT_COLOR_DISABLED;
alias BORDER_WIDTH = GuiControlProperty.BORDER_WIDTH;
alias TEXT_PADDING = GuiControlProperty.TEXT_PADDING;
alias TEXT_ALIGNMENT = GuiControlProperty.TEXT_ALIGNMENT;

// TODO: Which text styling properties should be global or per-control?
// At this moment TEXT_PADDING and TEXT_ALIGNMENT is configured and saved per control while
// TEXT_SIZE, TEXT_SPACING, TEXT_LINE_SPACING, TEXT_ALIGNMENT_VERTICAL, TEXT_WRAP_MODE are global and
// should be configured by user as needed while defining the UI layout

// Gui extended properties depend on control
// NOTE: RAYGUI_MAX_PROPS_EXTENDED properties (by default, max 8 properties)
//----------------------------------------------------------------------------------
// DEFAULT extended properties
// NOTE: Those properties are common to all controls or global
// WARNING: We only have 8 slots for those properties by default!!! -> New global control: TEXT?
enum GuiDefaultProperty
{
    TEXT_SIZE = 16, // Text size (glyphs max height)
    TEXT_SPACING = 17, // Text spacing between glyphs
    LINE_COLOR = 18, // Line control color
    BACKGROUND_COLOR = 19, // Background color
    TEXT_LINE_SPACING = 20, // Text spacing between lines
    TEXT_ALIGNMENT_VERTICAL = 21, // Text vertical alignment inside text bounds (after border and padding)
    TEXT_WRAP_MODE = 22 // Text wrap-mode inside text bounds
    //TEXT_DECORATION             // Text decoration: 0-None, 1-Underline, 2-Line-through, 3-Overline
    //TEXT_DECORATION_THICK       // Text decoration line thikness
}

alias TEXT_SIZE = GuiDefaultProperty.TEXT_SIZE;
alias TEXT_SPACING = GuiDefaultProperty.TEXT_SPACING;
alias LINE_COLOR = GuiDefaultProperty.LINE_COLOR;
alias BACKGROUND_COLOR = GuiDefaultProperty.BACKGROUND_COLOR;
alias TEXT_LINE_SPACING = GuiDefaultProperty.TEXT_LINE_SPACING;
alias TEXT_ALIGNMENT_VERTICAL = GuiDefaultProperty.TEXT_ALIGNMENT_VERTICAL;
alias TEXT_WRAP_MODE = GuiDefaultProperty.TEXT_WRAP_MODE;

// Other possible text properties:
// TEXT_WEIGHT                  // Normal, Italic, Bold -> Requires specific font change
// TEXT_INDENT	                // Text indentation -> Now using TEXT_PADDING...

// Label
//typedef enum { } GuiLabelProperty;

// Button/Spinner
//typedef enum { } GuiButtonProperty;

// Toggle/ToggleGroup
enum GuiToggleProperty
{
    GROUP_PADDING = 16 // ToggleGroup separation between toggles
}

alias GROUP_PADDING = GuiToggleProperty.GROUP_PADDING;

// Slider/SliderBar
enum GuiSliderProperty
{
    SLIDER_WIDTH = 16, // Slider size of internal bar
    SLIDER_PADDING = 17 // Slider/SliderBar internal bar padding
}

alias SLIDER_WIDTH = GuiSliderProperty.SLIDER_WIDTH;
alias SLIDER_PADDING = GuiSliderProperty.SLIDER_PADDING;

// ProgressBar
enum GuiProgressBarProperty
{
    PROGRESS_PADDING = 16 // ProgressBar internal padding
}

alias PROGRESS_PADDING = GuiProgressBarProperty.PROGRESS_PADDING;

// ScrollBar
enum GuiScrollBarProperty
{
    ARROWS_SIZE = 16, // ScrollBar arrows size
    ARROWS_VISIBLE = 17, // ScrollBar arrows visible
    SCROLL_SLIDER_PADDING = 18, // ScrollBar slider internal padding
    SCROLL_SLIDER_SIZE = 19, // ScrollBar slider size
    SCROLL_PADDING = 20, // ScrollBar scroll padding from arrows
    SCROLL_SPEED = 21 // ScrollBar scrolling speed
}

alias ARROWS_SIZE = GuiScrollBarProperty.ARROWS_SIZE;
alias ARROWS_VISIBLE = GuiScrollBarProperty.ARROWS_VISIBLE;
alias SCROLL_SLIDER_PADDING = GuiScrollBarProperty.SCROLL_SLIDER_PADDING;
alias SCROLL_SLIDER_SIZE = GuiScrollBarProperty.SCROLL_SLIDER_SIZE;
alias SCROLL_PADDING = GuiScrollBarProperty.SCROLL_PADDING;
alias SCROLL_SPEED = GuiScrollBarProperty.SCROLL_SPEED;

// CheckBox
enum GuiCheckBoxProperty
{
    CHECK_PADDING = 16 // CheckBox internal check padding
}

alias CHECK_PADDING = GuiCheckBoxProperty.CHECK_PADDING;

// ComboBox
enum GuiComboBoxProperty
{
    COMBO_BUTTON_WIDTH = 16, // ComboBox right button width
    COMBO_BUTTON_SPACING = 17 // ComboBox button separation
}

alias COMBO_BUTTON_WIDTH = GuiComboBoxProperty.COMBO_BUTTON_WIDTH;
alias COMBO_BUTTON_SPACING = GuiComboBoxProperty.COMBO_BUTTON_SPACING;

// DropdownBox
enum GuiDropdownBoxProperty
{
    ARROW_PADDING = 16, // DropdownBox arrow separation from border and items
    DROPDOWN_ITEMS_SPACING = 17 // DropdownBox items separation
}

alias ARROW_PADDING = GuiDropdownBoxProperty.ARROW_PADDING;
alias DROPDOWN_ITEMS_SPACING = GuiDropdownBoxProperty.DROPDOWN_ITEMS_SPACING;

// TextBox/TextBoxMulti/ValueBox/Spinner
enum GuiTextBoxProperty
{
    TEXT_READONLY = 16 // TextBox in read-only mode: 0-text editable, 1-text no-editable
}

alias TEXT_READONLY = GuiTextBoxProperty.TEXT_READONLY;

// Spinner
enum GuiSpinnerProperty
{
    SPIN_BUTTON_WIDTH = 16, // Spinner left/right buttons width
    SPIN_BUTTON_SPACING = 17 // Spinner buttons separation
}

alias SPIN_BUTTON_WIDTH = GuiSpinnerProperty.SPIN_BUTTON_WIDTH;
alias SPIN_BUTTON_SPACING = GuiSpinnerProperty.SPIN_BUTTON_SPACING;

// ListView
enum GuiListViewProperty
{
    LIST_ITEMS_HEIGHT = 16, // ListView items height
    LIST_ITEMS_SPACING = 17, // ListView items separation
    SCROLLBAR_WIDTH = 18, // ListView scrollbar size (usually width)
    SCROLLBAR_SIDE = 19 // ListView scrollbar side (0-SCROLLBAR_LEFT_SIDE, 1-SCROLLBAR_RIGHT_SIDE)
}

alias LIST_ITEMS_HEIGHT = GuiListViewProperty.LIST_ITEMS_HEIGHT;
alias LIST_ITEMS_SPACING = GuiListViewProperty.LIST_ITEMS_SPACING;
alias SCROLLBAR_WIDTH = GuiListViewProperty.SCROLLBAR_WIDTH;
alias SCROLLBAR_SIDE = GuiListViewProperty.SCROLLBAR_SIDE;

// ColorPicker
enum GuiColorPickerProperty
{
    COLOR_SELECTOR_SIZE = 16,
    HUEBAR_WIDTH = 17, // ColorPicker right hue bar width
    HUEBAR_PADDING = 18, // ColorPicker right hue bar separation from panel
    HUEBAR_SELECTOR_HEIGHT = 19, // ColorPicker right hue bar selector height
    HUEBAR_SELECTOR_OVERFLOW = 20 // ColorPicker right hue bar selector overflow
}

alias COLOR_SELECTOR_SIZE = GuiColorPickerProperty.COLOR_SELECTOR_SIZE;
alias HUEBAR_WIDTH = GuiColorPickerProperty.HUEBAR_WIDTH;
alias HUEBAR_PADDING = GuiColorPickerProperty.HUEBAR_PADDING;
alias HUEBAR_SELECTOR_HEIGHT = GuiColorPickerProperty.HUEBAR_SELECTOR_HEIGHT;
alias HUEBAR_SELECTOR_OVERFLOW = GuiColorPickerProperty.HUEBAR_SELECTOR_OVERFLOW;

enum SCROLLBAR_LEFT_SIDE = 0;
enum SCROLLBAR_RIGHT_SIDE = 1;

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
// ...

//----------------------------------------------------------------------------------
// Module Functions Declaration
//----------------------------------------------------------------------------------

// Prevents name mangling of functions

// Global gui state control functions
void GuiEnable (); // Enable gui controls (global state)
void GuiDisable (); // Disable gui controls (global state)
void GuiLock (); // Lock gui controls (global state)
void GuiUnlock (); // Unlock gui controls (global state)
bool GuiIsLocked (); // Check if gui is locked (global state)
void GuiSetAlpha (float alpha); // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
void GuiSetState (int state); // Set gui state (global state)
int GuiGetState (); // Get gui state (global state)

// Font set/get functions
void GuiSetFont (Font font); // Set gui custom font (global state)
Font GuiGetFont (); // Get gui custom font (global state)

// Style set/get functions
void GuiSetStyle (int control, int property, int value); // Set one style property
int GuiGetStyle (int control, int property); // Get one style property

// Styles loading functions
void GuiLoadStyle (const(char)* fileName); // Load style file over global style variable (.rgs)
void GuiLoadStyleDefault (); // Load style default over global style

// Tooltips management functions
void GuiEnableTooltip (); // Enable gui tooltips (global state)
void GuiDisableTooltip (); // Disable gui tooltips (global state)
void GuiSetTooltip (const(char)* tooltip); // Set tooltip string

// Icons functionality
const(char)* GuiIconText (int iconId, const(char)* text); // Get text with icon id prepended (if supported)

void GuiSetIconScale (int scale); // Set default icon drawing size
uint* GuiGetIcons (); // Get raygui icons data pointer
char** GuiLoadIcons (const(char)* fileName, bool loadIconsName); // Load raygui icons file (.rgi) into internal icons data
void GuiDrawIcon (int iconId, int posX, int posY, int pixelSize, Color color); // Draw icon using pixel size at specified position

// Controls
//----------------------------------------------------------------------------------------------------------
// Container/separator controls, useful for controls organization
int GuiWindowBox (Rectangle bounds, const(char)* title); // Window Box control, shows a window that can be closed
int GuiGroupBox (Rectangle bounds, const(char)* text); // Group Box control with text name
int GuiLine (Rectangle bounds, const(char)* text); // Line separator control, could contain text
int GuiPanel (Rectangle bounds, const(char)* text); // Panel control, useful to group controls
int GuiTabBar (Rectangle bounds, const(char*)* text, int count, int* active); // Tab Bar control, returns TAB to be closed or -1
int GuiScrollPanel (Rectangle bounds, const(char)* text, Rectangle content, Vector2* scroll, Rectangle* view); // Scroll Panel control

// Basic controls set
int GuiLabel (Rectangle bounds, const(char)* text); // Label control, shows text
int GuiButton (Rectangle bounds, const(char)* text); // Button control, returns true when clicked
int GuiLabelButton (Rectangle bounds, const(char)* text); // Label button control, show true when clicked
int GuiToggle (Rectangle bounds, const(char)* text, bool* active); // Toggle Button control, returns true when active
int GuiToggleGroup (Rectangle bounds, const(char)* text, int* active); // Toggle Group control, returns active toggle index
int GuiToggleSlider (Rectangle bounds, const(char)* text, int* active); // Toggle Slider control, returns true when clicked
int GuiCheckBox (Rectangle bounds, const(char)* text, bool* checked); // Check Box control, returns true when active
int GuiComboBox (Rectangle bounds, const(char)* text, int* active); // Combo Box control, returns selected item index

int GuiDropdownBox (Rectangle bounds, const(char)* text, int* active, bool editMode); // Dropdown Box control, returns selected item
int GuiSpinner (Rectangle bounds, const(char)* text, int* value, int minValue, int maxValue, bool editMode); // Spinner control, returns selected value
int GuiValueBox (Rectangle bounds, const(char)* text, int* value, int minValue, int maxValue, bool editMode); // Value Box control, updates input text with numbers
int GuiTextBox (Rectangle bounds, char* text, int textSize, bool editMode); // Text Box control, updates input text

int GuiSlider (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float* value, float minValue, float maxValue); // Slider control, returns selected value
int GuiSliderBar (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float* value, float minValue, float maxValue); // Slider Bar control, returns selected value
int GuiProgressBar (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float* value, float minValue, float maxValue); // Progress Bar control, shows current progress value
int GuiStatusBar (Rectangle bounds, const(char)* text); // Status Bar control, shows info text
int GuiDummyRec (Rectangle bounds, const(char)* text); // Dummy control for placeholders
int GuiGrid (Rectangle bounds, const(char)* text, float spacing, int subdivs, Vector2* mouseCell); // Grid control, returns mouse cell position

// Advance controls set
int GuiListView (Rectangle bounds, const(char)* text, int* scrollIndex, int* active); // List View control, returns selected list item index
int GuiListViewEx (Rectangle bounds, const(char*)* text, int count, int* scrollIndex, int* active, int* focus); // List View with extended parameters
int GuiMessageBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons); // Message Box control, displays a message
int GuiTextInputBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons, char* text, int textMaxSize, bool* secretViewActive); // Text Input Box control, ask for text, supports secret
int GuiColorPicker (Rectangle bounds, const(char)* text, Color* color); // Color Picker control (multiple color controls)
int GuiColorPanel (Rectangle bounds, const(char)* text, Color* color); // Color Panel control
int GuiColorBarAlpha (Rectangle bounds, const(char)* text, float* alpha); // Color Bar Alpha control
int GuiColorBarHue (Rectangle bounds, const(char)* text, float* value); // Color Bar Hue control
int GuiColorPickerHSV (Rectangle bounds, const(char)* text, Vector3* colorHsv); // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
int GuiColorPanelHSV (Rectangle bounds, const(char)* text, Vector3* colorHsv); // Color Panel control that returns HSV color value, used by GuiColorPickerHSV()
//----------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Icons enumeration
//----------------------------------------------------------------------------------
enum GuiIconName
{
    ICON_NONE = 0,
    ICON_FOLDER_FILE_OPEN = 1,
    ICON_FILE_SAVE_CLASSIC = 2,
    ICON_FOLDER_OPEN = 3,
    ICON_FOLDER_SAVE = 4,
    ICON_FILE_OPEN = 5,
    ICON_FILE_SAVE = 6,
    ICON_FILE_EXPORT = 7,
    ICON_FILE_ADD = 8,
    ICON_FILE_DELETE = 9,
    ICON_FILETYPE_TEXT = 10,
    ICON_FILETYPE_AUDIO = 11,
    ICON_FILETYPE_IMAGE = 12,
    ICON_FILETYPE_PLAY = 13,
    ICON_FILETYPE_VIDEO = 14,
    ICON_FILETYPE_INFO = 15,
    ICON_FILE_COPY = 16,
    ICON_FILE_CUT = 17,
    ICON_FILE_PASTE = 18,
    ICON_CURSOR_HAND = 19,
    ICON_CURSOR_POINTER = 20,
    ICON_CURSOR_CLASSIC = 21,
    ICON_PENCIL = 22,
    ICON_PENCIL_BIG = 23,
    ICON_BRUSH_CLASSIC = 24,
    ICON_BRUSH_PAINTER = 25,
    ICON_WATER_DROP = 26,
    ICON_COLOR_PICKER = 27,
    ICON_RUBBER = 28,
    ICON_COLOR_BUCKET = 29,
    ICON_TEXT_T = 30,
    ICON_TEXT_A = 31,
    ICON_SCALE = 32,
    ICON_RESIZE = 33,
    ICON_FILTER_POINT = 34,
    ICON_FILTER_BILINEAR = 35,
    ICON_CROP = 36,
    ICON_CROP_ALPHA = 37,
    ICON_SQUARE_TOGGLE = 38,
    ICON_SYMMETRY = 39,
    ICON_SYMMETRY_HORIZONTAL = 40,
    ICON_SYMMETRY_VERTICAL = 41,
    ICON_LENS = 42,
    ICON_LENS_BIG = 43,
    ICON_EYE_ON = 44,
    ICON_EYE_OFF = 45,
    ICON_FILTER_TOP = 46,
    ICON_FILTER = 47,
    ICON_TARGET_POINT = 48,
    ICON_TARGET_SMALL = 49,
    ICON_TARGET_BIG = 50,
    ICON_TARGET_MOVE = 51,
    ICON_CURSOR_MOVE = 52,
    ICON_CURSOR_SCALE = 53,
    ICON_CURSOR_SCALE_RIGHT = 54,
    ICON_CURSOR_SCALE_LEFT = 55,
    ICON_UNDO = 56,
    ICON_REDO = 57,
    ICON_REREDO = 58,
    ICON_MUTATE = 59,
    ICON_ROTATE = 60,
    ICON_REPEAT = 61,
    ICON_SHUFFLE = 62,
    ICON_EMPTYBOX = 63,
    ICON_TARGET = 64,
    ICON_TARGET_SMALL_FILL = 65,
    ICON_TARGET_BIG_FILL = 66,
    ICON_TARGET_MOVE_FILL = 67,
    ICON_CURSOR_MOVE_FILL = 68,
    ICON_CURSOR_SCALE_FILL = 69,
    ICON_CURSOR_SCALE_RIGHT_FILL = 70,
    ICON_CURSOR_SCALE_LEFT_FILL = 71,
    ICON_UNDO_FILL = 72,
    ICON_REDO_FILL = 73,
    ICON_REREDO_FILL = 74,
    ICON_MUTATE_FILL = 75,
    ICON_ROTATE_FILL = 76,
    ICON_REPEAT_FILL = 77,
    ICON_SHUFFLE_FILL = 78,
    ICON_EMPTYBOX_SMALL = 79,
    ICON_BOX = 80,
    ICON_BOX_TOP = 81,
    ICON_BOX_TOP_RIGHT = 82,
    ICON_BOX_RIGHT = 83,
    ICON_BOX_BOTTOM_RIGHT = 84,
    ICON_BOX_BOTTOM = 85,
    ICON_BOX_BOTTOM_LEFT = 86,
    ICON_BOX_LEFT = 87,
    ICON_BOX_TOP_LEFT = 88,
    ICON_BOX_CENTER = 89,
    ICON_BOX_CIRCLE_MASK = 90,
    ICON_POT = 91,
    ICON_ALPHA_MULTIPLY = 92,
    ICON_ALPHA_CLEAR = 93,
    ICON_DITHERING = 94,
    ICON_MIPMAPS = 95,
    ICON_BOX_GRID = 96,
    ICON_GRID = 97,
    ICON_BOX_CORNERS_SMALL = 98,
    ICON_BOX_CORNERS_BIG = 99,
    ICON_FOUR_BOXES = 100,
    ICON_GRID_FILL = 101,
    ICON_BOX_MULTISIZE = 102,
    ICON_ZOOM_SMALL = 103,
    ICON_ZOOM_MEDIUM = 104,
    ICON_ZOOM_BIG = 105,
    ICON_ZOOM_ALL = 106,
    ICON_ZOOM_CENTER = 107,
    ICON_BOX_DOTS_SMALL = 108,
    ICON_BOX_DOTS_BIG = 109,
    ICON_BOX_CONCENTRIC = 110,
    ICON_BOX_GRID_BIG = 111,
    ICON_OK_TICK = 112,
    ICON_CROSS = 113,
    ICON_ARROW_LEFT = 114,
    ICON_ARROW_RIGHT = 115,
    ICON_ARROW_DOWN = 116,
    ICON_ARROW_UP = 117,
    ICON_ARROW_LEFT_FILL = 118,
    ICON_ARROW_RIGHT_FILL = 119,
    ICON_ARROW_DOWN_FILL = 120,
    ICON_ARROW_UP_FILL = 121,
    ICON_AUDIO = 122,
    ICON_FX = 123,
    ICON_WAVE = 124,
    ICON_WAVE_SINUS = 125,
    ICON_WAVE_SQUARE = 126,
    ICON_WAVE_TRIANGULAR = 127,
    ICON_CROSS_SMALL = 128,
    ICON_PLAYER_PREVIOUS = 129,
    ICON_PLAYER_PLAY_BACK = 130,
    ICON_PLAYER_PLAY = 131,
    ICON_PLAYER_PAUSE = 132,
    ICON_PLAYER_STOP = 133,
    ICON_PLAYER_NEXT = 134,
    ICON_PLAYER_RECORD = 135,
    ICON_MAGNET = 136,
    ICON_LOCK_CLOSE = 137,
    ICON_LOCK_OPEN = 138,
    ICON_CLOCK = 139,
    ICON_TOOLS = 140,
    ICON_GEAR = 141,
    ICON_GEAR_BIG = 142,
    ICON_BIN = 143,
    ICON_HAND_POINTER = 144,
    ICON_LASER = 145,
    ICON_COIN = 146,
    ICON_EXPLOSION = 147,
    ICON_1UP = 148,
    ICON_PLAYER = 149,
    ICON_PLAYER_JUMP = 150,
    ICON_KEY = 151,
    ICON_DEMON = 152,
    ICON_TEXT_POPUP = 153,
    ICON_GEAR_EX = 154,
    ICON_CRACK = 155,
    ICON_CRACK_POINTS = 156,
    ICON_STAR = 157,
    ICON_DOOR = 158,
    ICON_EXIT = 159,
    ICON_MODE_2D = 160,
    ICON_MODE_3D = 161,
    ICON_CUBE = 162,
    ICON_CUBE_FACE_TOP = 163,
    ICON_CUBE_FACE_LEFT = 164,
    ICON_CUBE_FACE_FRONT = 165,
    ICON_CUBE_FACE_BOTTOM = 166,
    ICON_CUBE_FACE_RIGHT = 167,
    ICON_CUBE_FACE_BACK = 168,
    ICON_CAMERA = 169,
    ICON_SPECIAL = 170,
    ICON_LINK_NET = 171,
    ICON_LINK_BOXES = 172,
    ICON_LINK_MULTI = 173,
    ICON_LINK = 174,
    ICON_LINK_BROKE = 175,
    ICON_TEXT_NOTES = 176,
    ICON_NOTEBOOK = 177,
    ICON_SUITCASE = 178,
    ICON_SUITCASE_ZIP = 179,
    ICON_MAILBOX = 180,
    ICON_MONITOR = 181,
    ICON_PRINTER = 182,
    ICON_PHOTO_CAMERA = 183,
    ICON_PHOTO_CAMERA_FLASH = 184,
    ICON_HOUSE = 185,
    ICON_HEART = 186,
    ICON_CORNER = 187,
    ICON_VERTICAL_BARS = 188,
    ICON_VERTICAL_BARS_FILL = 189,
    ICON_LIFE_BARS = 190,
    ICON_INFO = 191,
    ICON_CROSSLINE = 192,
    ICON_HELP = 193,
    ICON_FILETYPE_ALPHA = 194,
    ICON_FILETYPE_HOME = 195,
    ICON_LAYERS_VISIBLE = 196,
    ICON_LAYERS = 197,
    ICON_WINDOW = 198,
    ICON_HIDPI = 199,
    ICON_FILETYPE_BINARY = 200,
    ICON_HEX = 201,
    ICON_SHIELD = 202,
    ICON_FILE_NEW = 203,
    ICON_FOLDER_ADD = 204,
    ICON_ALARM = 205,
    ICON_CPU = 206,
    ICON_ROM = 207,
    ICON_STEP_OVER = 208,
    ICON_STEP_INTO = 209,
    ICON_STEP_OUT = 210,
    ICON_RESTART = 211,
    ICON_BREAKPOINT_ON = 212,
    ICON_BREAKPOINT_OFF = 213,
    ICON_BURGER_MENU = 214,
    ICON_CASE_SENSITIVE = 215,
    ICON_REG_EXP = 216,
    ICON_FOLDER = 217,
    ICON_FILE = 218,
    ICON_SAND_TIMER = 219,
    ICON_220 = 220,
    ICON_221 = 221,
    ICON_222 = 222,
    ICON_223 = 223,
    ICON_224 = 224,
    ICON_225 = 225,
    ICON_226 = 226,
    ICON_227 = 227,
    ICON_228 = 228,
    ICON_229 = 229,
    ICON_230 = 230,
    ICON_231 = 231,
    ICON_232 = 232,
    ICON_233 = 233,
    ICON_234 = 234,
    ICON_235 = 235,
    ICON_236 = 236,
    ICON_237 = 237,
    ICON_238 = 238,
    ICON_239 = 239,
    ICON_240 = 240,
    ICON_241 = 241,
    ICON_242 = 242,
    ICON_243 = 243,
    ICON_244 = 244,
    ICON_245 = 245,
    ICON_246 = 246,
    ICON_247 = 247,
    ICON_248 = 248,
    ICON_249 = 249,
    ICON_250 = 250,
    ICON_251 = 251,
    ICON_252 = 252,
    ICON_253 = 253,
    ICON_254 = 254,
    ICON_255 = 255
}

alias ICON_NONE = GuiIconName.ICON_NONE;
alias ICON_FOLDER_FILE_OPEN = GuiIconName.ICON_FOLDER_FILE_OPEN;
alias ICON_FILE_SAVE_CLASSIC = GuiIconName.ICON_FILE_SAVE_CLASSIC;
alias ICON_FOLDER_OPEN = GuiIconName.ICON_FOLDER_OPEN;
alias ICON_FOLDER_SAVE = GuiIconName.ICON_FOLDER_SAVE;
alias ICON_FILE_OPEN = GuiIconName.ICON_FILE_OPEN;
alias ICON_FILE_SAVE = GuiIconName.ICON_FILE_SAVE;
alias ICON_FILE_EXPORT = GuiIconName.ICON_FILE_EXPORT;
alias ICON_FILE_ADD = GuiIconName.ICON_FILE_ADD;
alias ICON_FILE_DELETE = GuiIconName.ICON_FILE_DELETE;
alias ICON_FILETYPE_TEXT = GuiIconName.ICON_FILETYPE_TEXT;
alias ICON_FILETYPE_AUDIO = GuiIconName.ICON_FILETYPE_AUDIO;
alias ICON_FILETYPE_IMAGE = GuiIconName.ICON_FILETYPE_IMAGE;
alias ICON_FILETYPE_PLAY = GuiIconName.ICON_FILETYPE_PLAY;
alias ICON_FILETYPE_VIDEO = GuiIconName.ICON_FILETYPE_VIDEO;
alias ICON_FILETYPE_INFO = GuiIconName.ICON_FILETYPE_INFO;
alias ICON_FILE_COPY = GuiIconName.ICON_FILE_COPY;
alias ICON_FILE_CUT = GuiIconName.ICON_FILE_CUT;
alias ICON_FILE_PASTE = GuiIconName.ICON_FILE_PASTE;
alias ICON_CURSOR_HAND = GuiIconName.ICON_CURSOR_HAND;
alias ICON_CURSOR_POINTER = GuiIconName.ICON_CURSOR_POINTER;
alias ICON_CURSOR_CLASSIC = GuiIconName.ICON_CURSOR_CLASSIC;
alias ICON_PENCIL = GuiIconName.ICON_PENCIL;
alias ICON_PENCIL_BIG = GuiIconName.ICON_PENCIL_BIG;
alias ICON_BRUSH_CLASSIC = GuiIconName.ICON_BRUSH_CLASSIC;
alias ICON_BRUSH_PAINTER = GuiIconName.ICON_BRUSH_PAINTER;
alias ICON_WATER_DROP = GuiIconName.ICON_WATER_DROP;
alias ICON_COLOR_PICKER = GuiIconName.ICON_COLOR_PICKER;
alias ICON_RUBBER = GuiIconName.ICON_RUBBER;
alias ICON_COLOR_BUCKET = GuiIconName.ICON_COLOR_BUCKET;
alias ICON_TEXT_T = GuiIconName.ICON_TEXT_T;
alias ICON_TEXT_A = GuiIconName.ICON_TEXT_A;
alias ICON_SCALE = GuiIconName.ICON_SCALE;
alias ICON_RESIZE = GuiIconName.ICON_RESIZE;
alias ICON_FILTER_POINT = GuiIconName.ICON_FILTER_POINT;
alias ICON_FILTER_BILINEAR = GuiIconName.ICON_FILTER_BILINEAR;
alias ICON_CROP = GuiIconName.ICON_CROP;
alias ICON_CROP_ALPHA = GuiIconName.ICON_CROP_ALPHA;
alias ICON_SQUARE_TOGGLE = GuiIconName.ICON_SQUARE_TOGGLE;
alias ICON_SYMMETRY = GuiIconName.ICON_SYMMETRY;
alias ICON_SYMMETRY_HORIZONTAL = GuiIconName.ICON_SYMMETRY_HORIZONTAL;
alias ICON_SYMMETRY_VERTICAL = GuiIconName.ICON_SYMMETRY_VERTICAL;
alias ICON_LENS = GuiIconName.ICON_LENS;
alias ICON_LENS_BIG = GuiIconName.ICON_LENS_BIG;
alias ICON_EYE_ON = GuiIconName.ICON_EYE_ON;
alias ICON_EYE_OFF = GuiIconName.ICON_EYE_OFF;
alias ICON_FILTER_TOP = GuiIconName.ICON_FILTER_TOP;
alias ICON_FILTER = GuiIconName.ICON_FILTER;
alias ICON_TARGET_POINT = GuiIconName.ICON_TARGET_POINT;
alias ICON_TARGET_SMALL = GuiIconName.ICON_TARGET_SMALL;
alias ICON_TARGET_BIG = GuiIconName.ICON_TARGET_BIG;
alias ICON_TARGET_MOVE = GuiIconName.ICON_TARGET_MOVE;
alias ICON_CURSOR_MOVE = GuiIconName.ICON_CURSOR_MOVE;
alias ICON_CURSOR_SCALE = GuiIconName.ICON_CURSOR_SCALE;
alias ICON_CURSOR_SCALE_RIGHT = GuiIconName.ICON_CURSOR_SCALE_RIGHT;
alias ICON_CURSOR_SCALE_LEFT = GuiIconName.ICON_CURSOR_SCALE_LEFT;
alias ICON_UNDO = GuiIconName.ICON_UNDO;
alias ICON_REDO = GuiIconName.ICON_REDO;
alias ICON_REREDO = GuiIconName.ICON_REREDO;
alias ICON_MUTATE = GuiIconName.ICON_MUTATE;
alias ICON_ROTATE = GuiIconName.ICON_ROTATE;
alias ICON_REPEAT = GuiIconName.ICON_REPEAT;
alias ICON_SHUFFLE = GuiIconName.ICON_SHUFFLE;
alias ICON_EMPTYBOX = GuiIconName.ICON_EMPTYBOX;
alias ICON_TARGET = GuiIconName.ICON_TARGET;
alias ICON_TARGET_SMALL_FILL = GuiIconName.ICON_TARGET_SMALL_FILL;
alias ICON_TARGET_BIG_FILL = GuiIconName.ICON_TARGET_BIG_FILL;
alias ICON_TARGET_MOVE_FILL = GuiIconName.ICON_TARGET_MOVE_FILL;
alias ICON_CURSOR_MOVE_FILL = GuiIconName.ICON_CURSOR_MOVE_FILL;
alias ICON_CURSOR_SCALE_FILL = GuiIconName.ICON_CURSOR_SCALE_FILL;
alias ICON_CURSOR_SCALE_RIGHT_FILL = GuiIconName.ICON_CURSOR_SCALE_RIGHT_FILL;
alias ICON_CURSOR_SCALE_LEFT_FILL = GuiIconName.ICON_CURSOR_SCALE_LEFT_FILL;
alias ICON_UNDO_FILL = GuiIconName.ICON_UNDO_FILL;
alias ICON_REDO_FILL = GuiIconName.ICON_REDO_FILL;
alias ICON_REREDO_FILL = GuiIconName.ICON_REREDO_FILL;
alias ICON_MUTATE_FILL = GuiIconName.ICON_MUTATE_FILL;
alias ICON_ROTATE_FILL = GuiIconName.ICON_ROTATE_FILL;
alias ICON_REPEAT_FILL = GuiIconName.ICON_REPEAT_FILL;
alias ICON_SHUFFLE_FILL = GuiIconName.ICON_SHUFFLE_FILL;
alias ICON_EMPTYBOX_SMALL = GuiIconName.ICON_EMPTYBOX_SMALL;
alias ICON_BOX = GuiIconName.ICON_BOX;
alias ICON_BOX_TOP = GuiIconName.ICON_BOX_TOP;
alias ICON_BOX_TOP_RIGHT = GuiIconName.ICON_BOX_TOP_RIGHT;
alias ICON_BOX_RIGHT = GuiIconName.ICON_BOX_RIGHT;
alias ICON_BOX_BOTTOM_RIGHT = GuiIconName.ICON_BOX_BOTTOM_RIGHT;
alias ICON_BOX_BOTTOM = GuiIconName.ICON_BOX_BOTTOM;
alias ICON_BOX_BOTTOM_LEFT = GuiIconName.ICON_BOX_BOTTOM_LEFT;
alias ICON_BOX_LEFT = GuiIconName.ICON_BOX_LEFT;
alias ICON_BOX_TOP_LEFT = GuiIconName.ICON_BOX_TOP_LEFT;
alias ICON_BOX_CENTER = GuiIconName.ICON_BOX_CENTER;
alias ICON_BOX_CIRCLE_MASK = GuiIconName.ICON_BOX_CIRCLE_MASK;
alias ICON_POT = GuiIconName.ICON_POT;
alias ICON_ALPHA_MULTIPLY = GuiIconName.ICON_ALPHA_MULTIPLY;
alias ICON_ALPHA_CLEAR = GuiIconName.ICON_ALPHA_CLEAR;
alias ICON_DITHERING = GuiIconName.ICON_DITHERING;
alias ICON_MIPMAPS = GuiIconName.ICON_MIPMAPS;
alias ICON_BOX_GRID = GuiIconName.ICON_BOX_GRID;
alias ICON_GRID = GuiIconName.ICON_GRID;
alias ICON_BOX_CORNERS_SMALL = GuiIconName.ICON_BOX_CORNERS_SMALL;
alias ICON_BOX_CORNERS_BIG = GuiIconName.ICON_BOX_CORNERS_BIG;
alias ICON_FOUR_BOXES = GuiIconName.ICON_FOUR_BOXES;
alias ICON_GRID_FILL = GuiIconName.ICON_GRID_FILL;
alias ICON_BOX_MULTISIZE = GuiIconName.ICON_BOX_MULTISIZE;
alias ICON_ZOOM_SMALL = GuiIconName.ICON_ZOOM_SMALL;
alias ICON_ZOOM_MEDIUM = GuiIconName.ICON_ZOOM_MEDIUM;
alias ICON_ZOOM_BIG = GuiIconName.ICON_ZOOM_BIG;
alias ICON_ZOOM_ALL = GuiIconName.ICON_ZOOM_ALL;
alias ICON_ZOOM_CENTER = GuiIconName.ICON_ZOOM_CENTER;
alias ICON_BOX_DOTS_SMALL = GuiIconName.ICON_BOX_DOTS_SMALL;
alias ICON_BOX_DOTS_BIG = GuiIconName.ICON_BOX_DOTS_BIG;
alias ICON_BOX_CONCENTRIC = GuiIconName.ICON_BOX_CONCENTRIC;
alias ICON_BOX_GRID_BIG = GuiIconName.ICON_BOX_GRID_BIG;
alias ICON_OK_TICK = GuiIconName.ICON_OK_TICK;
alias ICON_CROSS = GuiIconName.ICON_CROSS;
alias ICON_ARROW_LEFT = GuiIconName.ICON_ARROW_LEFT;
alias ICON_ARROW_RIGHT = GuiIconName.ICON_ARROW_RIGHT;
alias ICON_ARROW_DOWN = GuiIconName.ICON_ARROW_DOWN;
alias ICON_ARROW_UP = GuiIconName.ICON_ARROW_UP;
alias ICON_ARROW_LEFT_FILL = GuiIconName.ICON_ARROW_LEFT_FILL;
alias ICON_ARROW_RIGHT_FILL = GuiIconName.ICON_ARROW_RIGHT_FILL;
alias ICON_ARROW_DOWN_FILL = GuiIconName.ICON_ARROW_DOWN_FILL;
alias ICON_ARROW_UP_FILL = GuiIconName.ICON_ARROW_UP_FILL;
alias ICON_AUDIO = GuiIconName.ICON_AUDIO;
alias ICON_FX = GuiIconName.ICON_FX;
alias ICON_WAVE = GuiIconName.ICON_WAVE;
alias ICON_WAVE_SINUS = GuiIconName.ICON_WAVE_SINUS;
alias ICON_WAVE_SQUARE = GuiIconName.ICON_WAVE_SQUARE;
alias ICON_WAVE_TRIANGULAR = GuiIconName.ICON_WAVE_TRIANGULAR;
alias ICON_CROSS_SMALL = GuiIconName.ICON_CROSS_SMALL;
alias ICON_PLAYER_PREVIOUS = GuiIconName.ICON_PLAYER_PREVIOUS;
alias ICON_PLAYER_PLAY_BACK = GuiIconName.ICON_PLAYER_PLAY_BACK;
alias ICON_PLAYER_PLAY = GuiIconName.ICON_PLAYER_PLAY;
alias ICON_PLAYER_PAUSE = GuiIconName.ICON_PLAYER_PAUSE;
alias ICON_PLAYER_STOP = GuiIconName.ICON_PLAYER_STOP;
alias ICON_PLAYER_NEXT = GuiIconName.ICON_PLAYER_NEXT;
alias ICON_PLAYER_RECORD = GuiIconName.ICON_PLAYER_RECORD;
alias ICON_MAGNET = GuiIconName.ICON_MAGNET;
alias ICON_LOCK_CLOSE = GuiIconName.ICON_LOCK_CLOSE;
alias ICON_LOCK_OPEN = GuiIconName.ICON_LOCK_OPEN;
alias ICON_CLOCK = GuiIconName.ICON_CLOCK;
alias ICON_TOOLS = GuiIconName.ICON_TOOLS;
alias ICON_GEAR = GuiIconName.ICON_GEAR;
alias ICON_GEAR_BIG = GuiIconName.ICON_GEAR_BIG;
alias ICON_BIN = GuiIconName.ICON_BIN;
alias ICON_HAND_POINTER = GuiIconName.ICON_HAND_POINTER;
alias ICON_LASER = GuiIconName.ICON_LASER;
alias ICON_COIN = GuiIconName.ICON_COIN;
alias ICON_EXPLOSION = GuiIconName.ICON_EXPLOSION;
alias ICON_1UP = GuiIconName.ICON_1UP;
alias ICON_PLAYER = GuiIconName.ICON_PLAYER;
alias ICON_PLAYER_JUMP = GuiIconName.ICON_PLAYER_JUMP;
alias ICON_KEY = GuiIconName.ICON_KEY;
alias ICON_DEMON = GuiIconName.ICON_DEMON;
alias ICON_TEXT_POPUP = GuiIconName.ICON_TEXT_POPUP;
alias ICON_GEAR_EX = GuiIconName.ICON_GEAR_EX;
alias ICON_CRACK = GuiIconName.ICON_CRACK;
alias ICON_CRACK_POINTS = GuiIconName.ICON_CRACK_POINTS;
alias ICON_STAR = GuiIconName.ICON_STAR;
alias ICON_DOOR = GuiIconName.ICON_DOOR;
alias ICON_EXIT = GuiIconName.ICON_EXIT;
alias ICON_MODE_2D = GuiIconName.ICON_MODE_2D;
alias ICON_MODE_3D = GuiIconName.ICON_MODE_3D;
alias ICON_CUBE = GuiIconName.ICON_CUBE;
alias ICON_CUBE_FACE_TOP = GuiIconName.ICON_CUBE_FACE_TOP;
alias ICON_CUBE_FACE_LEFT = GuiIconName.ICON_CUBE_FACE_LEFT;
alias ICON_CUBE_FACE_FRONT = GuiIconName.ICON_CUBE_FACE_FRONT;
alias ICON_CUBE_FACE_BOTTOM = GuiIconName.ICON_CUBE_FACE_BOTTOM;
alias ICON_CUBE_FACE_RIGHT = GuiIconName.ICON_CUBE_FACE_RIGHT;
alias ICON_CUBE_FACE_BACK = GuiIconName.ICON_CUBE_FACE_BACK;
alias ICON_CAMERA = GuiIconName.ICON_CAMERA;
alias ICON_SPECIAL = GuiIconName.ICON_SPECIAL;
alias ICON_LINK_NET = GuiIconName.ICON_LINK_NET;
alias ICON_LINK_BOXES = GuiIconName.ICON_LINK_BOXES;
alias ICON_LINK_MULTI = GuiIconName.ICON_LINK_MULTI;
alias ICON_LINK = GuiIconName.ICON_LINK;
alias ICON_LINK_BROKE = GuiIconName.ICON_LINK_BROKE;
alias ICON_TEXT_NOTES = GuiIconName.ICON_TEXT_NOTES;
alias ICON_NOTEBOOK = GuiIconName.ICON_NOTEBOOK;
alias ICON_SUITCASE = GuiIconName.ICON_SUITCASE;
alias ICON_SUITCASE_ZIP = GuiIconName.ICON_SUITCASE_ZIP;
alias ICON_MAILBOX = GuiIconName.ICON_MAILBOX;
alias ICON_MONITOR = GuiIconName.ICON_MONITOR;
alias ICON_PRINTER = GuiIconName.ICON_PRINTER;
alias ICON_PHOTO_CAMERA = GuiIconName.ICON_PHOTO_CAMERA;
alias ICON_PHOTO_CAMERA_FLASH = GuiIconName.ICON_PHOTO_CAMERA_FLASH;
alias ICON_HOUSE = GuiIconName.ICON_HOUSE;
alias ICON_HEART = GuiIconName.ICON_HEART;
alias ICON_CORNER = GuiIconName.ICON_CORNER;
alias ICON_VERTICAL_BARS = GuiIconName.ICON_VERTICAL_BARS;
alias ICON_VERTICAL_BARS_FILL = GuiIconName.ICON_VERTICAL_BARS_FILL;
alias ICON_LIFE_BARS = GuiIconName.ICON_LIFE_BARS;
alias ICON_INFO = GuiIconName.ICON_INFO;
alias ICON_CROSSLINE = GuiIconName.ICON_CROSSLINE;
alias ICON_HELP = GuiIconName.ICON_HELP;
alias ICON_FILETYPE_ALPHA = GuiIconName.ICON_FILETYPE_ALPHA;
alias ICON_FILETYPE_HOME = GuiIconName.ICON_FILETYPE_HOME;
alias ICON_LAYERS_VISIBLE = GuiIconName.ICON_LAYERS_VISIBLE;
alias ICON_LAYERS = GuiIconName.ICON_LAYERS;
alias ICON_WINDOW = GuiIconName.ICON_WINDOW;
alias ICON_HIDPI = GuiIconName.ICON_HIDPI;
alias ICON_FILETYPE_BINARY = GuiIconName.ICON_FILETYPE_BINARY;
alias ICON_HEX = GuiIconName.ICON_HEX;
alias ICON_SHIELD = GuiIconName.ICON_SHIELD;
alias ICON_FILE_NEW = GuiIconName.ICON_FILE_NEW;
alias ICON_FOLDER_ADD = GuiIconName.ICON_FOLDER_ADD;
alias ICON_ALARM = GuiIconName.ICON_ALARM;
alias ICON_CPU = GuiIconName.ICON_CPU;
alias ICON_ROM = GuiIconName.ICON_ROM;
alias ICON_STEP_OVER = GuiIconName.ICON_STEP_OVER;
alias ICON_STEP_INTO = GuiIconName.ICON_STEP_INTO;
alias ICON_STEP_OUT = GuiIconName.ICON_STEP_OUT;
alias ICON_RESTART = GuiIconName.ICON_RESTART;
alias ICON_BREAKPOINT_ON = GuiIconName.ICON_BREAKPOINT_ON;
alias ICON_BREAKPOINT_OFF = GuiIconName.ICON_BREAKPOINT_OFF;
alias ICON_BURGER_MENU = GuiIconName.ICON_BURGER_MENU;
alias ICON_CASE_SENSITIVE = GuiIconName.ICON_CASE_SENSITIVE;
alias ICON_REG_EXP = GuiIconName.ICON_REG_EXP;
alias ICON_FOLDER = GuiIconName.ICON_FOLDER;
alias ICON_FILE = GuiIconName.ICON_FILE;
alias ICON_SAND_TIMER = GuiIconName.ICON_SAND_TIMER;
alias ICON_220 = GuiIconName.ICON_220;
alias ICON_221 = GuiIconName.ICON_221;
alias ICON_222 = GuiIconName.ICON_222;
alias ICON_223 = GuiIconName.ICON_223;
alias ICON_224 = GuiIconName.ICON_224;
alias ICON_225 = GuiIconName.ICON_225;
alias ICON_226 = GuiIconName.ICON_226;
alias ICON_227 = GuiIconName.ICON_227;
alias ICON_228 = GuiIconName.ICON_228;
alias ICON_229 = GuiIconName.ICON_229;
alias ICON_230 = GuiIconName.ICON_230;
alias ICON_231 = GuiIconName.ICON_231;
alias ICON_232 = GuiIconName.ICON_232;
alias ICON_233 = GuiIconName.ICON_233;
alias ICON_234 = GuiIconName.ICON_234;
alias ICON_235 = GuiIconName.ICON_235;
alias ICON_236 = GuiIconName.ICON_236;
alias ICON_237 = GuiIconName.ICON_237;
alias ICON_238 = GuiIconName.ICON_238;
alias ICON_239 = GuiIconName.ICON_239;
alias ICON_240 = GuiIconName.ICON_240;
alias ICON_241 = GuiIconName.ICON_241;
alias ICON_242 = GuiIconName.ICON_242;
alias ICON_243 = GuiIconName.ICON_243;
alias ICON_244 = GuiIconName.ICON_244;
alias ICON_245 = GuiIconName.ICON_245;
alias ICON_246 = GuiIconName.ICON_246;
alias ICON_247 = GuiIconName.ICON_247;
alias ICON_248 = GuiIconName.ICON_248;
alias ICON_249 = GuiIconName.ICON_249;
alias ICON_250 = GuiIconName.ICON_250;
alias ICON_251 = GuiIconName.ICON_251;
alias ICON_252 = GuiIconName.ICON_252;
alias ICON_253 = GuiIconName.ICON_253;
alias ICON_254 = GuiIconName.ICON_254;
alias ICON_255 = GuiIconName.ICON_255;

// Prevents name mangling of functions

// RAYGUI_H

/***********************************************************************************
*
*   RAYGUI IMPLEMENTATION
*
************************************************************************************/

// Required for: FILE, fopen(), fclose(), fprintf(), feof(), fscanf(), vsprintf() [GuiLoadStyle(), GuiLoadIcons()]
// Required for: malloc(), calloc(), free() [GuiLoadStyle(), GuiLoadIcons()]
// Required for: strlen() [GuiTextBox(), GuiValueBox()], memset(), memcpy()
// Required for: va_list, va_start(), vfprintf(), va_end() [TextFormat()]
// Required for: roundf() [GuiColorPicker()]

// Check if two rectangles are equal, used to validate a slider bounds as an id

// Embedded icons, no external file provided
// Size of icons in pixels (squared)
// Maximum number of icons
// Maximum length of icon name id

// Icons data is defined by bit array (every bit represents one pixel)
// Those arrays are stored as unsigned int data arrays, so,
// every array element defines 32 pixels (bits) of information
// One icon is defined by 8 int, (8 int * 32 bit = 256 bit = 16*16 pixels)
// NOTE: Number of elemens depend on RAYGUI_ICON_SIZE (by default 16x16 pixels)

//----------------------------------------------------------------------------------
// Icons data for all gui possible icons (allocated on data segment by default)
//
// NOTE 1: Every icon is codified in binary form, using 1 bit per pixel, so,
// every 16x16 icon requires 8 integers (16*16/32) to be stored
//
// NOTE 2: A different icon set could be loaded over this array using GuiLoadIcons(),
// but loaded icons set must be same RAYGUI_ICON_SIZE and no more than RAYGUI_ICON_MAX_ICONS
//
// guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
//----------------------------------------------------------------------------------

// ICON_NONE
// ICON_FOLDER_FILE_OPEN
// ICON_FILE_SAVE_CLASSIC
// ICON_FOLDER_OPEN
// ICON_FOLDER_SAVE
// ICON_FILE_OPEN
// ICON_FILE_SAVE
// ICON_FILE_EXPORT
// ICON_FILE_ADD
// ICON_FILE_DELETE
// ICON_FILETYPE_TEXT
// ICON_FILETYPE_AUDIO
// ICON_FILETYPE_IMAGE
// ICON_FILETYPE_PLAY
// ICON_FILETYPE_VIDEO
// ICON_FILETYPE_INFO
// ICON_FILE_COPY
// ICON_FILE_CUT
// ICON_FILE_PASTE
// ICON_CURSOR_HAND
// ICON_CURSOR_POINTER
// ICON_CURSOR_CLASSIC
// ICON_PENCIL
// ICON_PENCIL_BIG
// ICON_BRUSH_CLASSIC
// ICON_BRUSH_PAINTER
// ICON_WATER_DROP
// ICON_COLOR_PICKER
// ICON_RUBBER
// ICON_COLOR_BUCKET
// ICON_TEXT_T
// ICON_TEXT_A
// ICON_SCALE
// ICON_RESIZE
// ICON_FILTER_POINT
// ICON_FILTER_BILINEAR
// ICON_CROP
// ICON_CROP_ALPHA
// ICON_SQUARE_TOGGLE
// ICON_SYMMETRY
// ICON_SYMMETRY_HORIZONTAL
// ICON_SYMMETRY_VERTICAL
// ICON_LENS
// ICON_LENS_BIG
// ICON_EYE_ON
// ICON_EYE_OFF
// ICON_FILTER_TOP
// ICON_FILTER
// ICON_TARGET_POINT
// ICON_TARGET_SMALL
// ICON_TARGET_BIG
// ICON_TARGET_MOVE
// ICON_CURSOR_MOVE
// ICON_CURSOR_SCALE
// ICON_CURSOR_SCALE_RIGHT
// ICON_CURSOR_SCALE_LEFT
// ICON_UNDO
// ICON_REDO
// ICON_REREDO
// ICON_MUTATE
// ICON_ROTATE
// ICON_REPEAT
// ICON_SHUFFLE
// ICON_EMPTYBOX
// ICON_TARGET
// ICON_TARGET_SMALL_FILL
// ICON_TARGET_BIG_FILL
// ICON_TARGET_MOVE_FILL
// ICON_CURSOR_MOVE_FILL
// ICON_CURSOR_SCALE_FILL
// ICON_CURSOR_SCALE_RIGHT_FILL
// ICON_CURSOR_SCALE_LEFT_FILL
// ICON_UNDO_FILL
// ICON_REDO_FILL
// ICON_REREDO_FILL
// ICON_MUTATE_FILL
// ICON_ROTATE_FILL
// ICON_REPEAT_FILL
// ICON_SHUFFLE_FILL
// ICON_EMPTYBOX_SMALL
// ICON_BOX
// ICON_BOX_TOP
// ICON_BOX_TOP_RIGHT
// ICON_BOX_RIGHT
// ICON_BOX_BOTTOM_RIGHT
// ICON_BOX_BOTTOM
// ICON_BOX_BOTTOM_LEFT
// ICON_BOX_LEFT
// ICON_BOX_TOP_LEFT
// ICON_BOX_CENTER
// ICON_BOX_CIRCLE_MASK
// ICON_POT
// ICON_ALPHA_MULTIPLY
// ICON_ALPHA_CLEAR
// ICON_DITHERING
// ICON_MIPMAPS
// ICON_BOX_GRID
// ICON_GRID
// ICON_BOX_CORNERS_SMALL
// ICON_BOX_CORNERS_BIG
// ICON_FOUR_BOXES
// ICON_GRID_FILL
// ICON_BOX_MULTISIZE
// ICON_ZOOM_SMALL
// ICON_ZOOM_MEDIUM
// ICON_ZOOM_BIG
// ICON_ZOOM_ALL
// ICON_ZOOM_CENTER
// ICON_BOX_DOTS_SMALL
// ICON_BOX_DOTS_BIG
// ICON_BOX_CONCENTRIC
// ICON_BOX_GRID_BIG
// ICON_OK_TICK
// ICON_CROSS
// ICON_ARROW_LEFT
// ICON_ARROW_RIGHT
// ICON_ARROW_DOWN
// ICON_ARROW_UP
// ICON_ARROW_LEFT_FILL
// ICON_ARROW_RIGHT_FILL
// ICON_ARROW_DOWN_FILL
// ICON_ARROW_UP_FILL
// ICON_AUDIO
// ICON_FX
// ICON_WAVE
// ICON_WAVE_SINUS
// ICON_WAVE_SQUARE
// ICON_WAVE_TRIANGULAR
// ICON_CROSS_SMALL
// ICON_PLAYER_PREVIOUS
// ICON_PLAYER_PLAY_BACK
// ICON_PLAYER_PLAY
// ICON_PLAYER_PAUSE
// ICON_PLAYER_STOP
// ICON_PLAYER_NEXT
// ICON_PLAYER_RECORD
// ICON_MAGNET
// ICON_LOCK_CLOSE
// ICON_LOCK_OPEN
// ICON_CLOCK
// ICON_TOOLS
// ICON_GEAR
// ICON_GEAR_BIG
// ICON_BIN
// ICON_HAND_POINTER
// ICON_LASER
// ICON_COIN
// ICON_EXPLOSION
// ICON_1UP
// ICON_PLAYER
// ICON_PLAYER_JUMP
// ICON_KEY
// ICON_DEMON
// ICON_TEXT_POPUP
// ICON_GEAR_EX
// ICON_CRACK
// ICON_CRACK_POINTS
// ICON_STAR
// ICON_DOOR
// ICON_EXIT
// ICON_MODE_2D
// ICON_MODE_3D
// ICON_CUBE
// ICON_CUBE_FACE_TOP
// ICON_CUBE_FACE_LEFT
// ICON_CUBE_FACE_FRONT
// ICON_CUBE_FACE_BOTTOM
// ICON_CUBE_FACE_RIGHT
// ICON_CUBE_FACE_BACK
// ICON_CAMERA
// ICON_SPECIAL
// ICON_LINK_NET
// ICON_LINK_BOXES
// ICON_LINK_MULTI
// ICON_LINK
// ICON_LINK_BROKE
// ICON_TEXT_NOTES
// ICON_NOTEBOOK
// ICON_SUITCASE
// ICON_SUITCASE_ZIP
// ICON_MAILBOX
// ICON_MONITOR
// ICON_PRINTER
// ICON_PHOTO_CAMERA
// ICON_PHOTO_CAMERA_FLASH
// ICON_HOUSE
// ICON_HEART
// ICON_CORNER
// ICON_VERTICAL_BARS
// ICON_VERTICAL_BARS_FILL
// ICON_LIFE_BARS
// ICON_INFO
// ICON_CROSSLINE
// ICON_HELP
// ICON_FILETYPE_ALPHA
// ICON_FILETYPE_HOME
// ICON_LAYERS_VISIBLE
// ICON_LAYERS
// ICON_WINDOW
// ICON_HIDPI
// ICON_FILETYPE_BINARY
// ICON_HEX
// ICON_SHIELD
// ICON_FILE_NEW
// ICON_FOLDER_ADD
// ICON_ALARM
// ICON_CPU
// ICON_ROM
// ICON_STEP_OVER
// ICON_STEP_INTO
// ICON_STEP_OUT
// ICON_RESTART
// ICON_BREAKPOINT_ON
// ICON_BREAKPOINT_OFF
// ICON_BURGER_MENU
// ICON_CASE_SENSITIVE
// ICON_REG_EXP
// ICON_FOLDER
// ICON_FILE
// ICON_SAND_TIMER
// ICON_220
// ICON_221
// ICON_222
// ICON_223
// ICON_224
// ICON_225
// ICON_226
// ICON_227
// ICON_228
// ICON_229
// ICON_230
// ICON_231
// ICON_232
// ICON_233
// ICON_234
// ICON_235
// ICON_236
// ICON_237
// ICON_238
// ICON_239
// ICON_240
// ICON_241
// ICON_242
// ICON_243
// ICON_244
// ICON_245
// ICON_246
// ICON_247
// ICON_248
// ICON_249
// ICON_250
// ICON_251
// ICON_252
// ICON_253
// ICON_254
// ICON_255

// NOTE: We keep a pointer to the icons array, useful to point to other sets if required

// !RAYGUI_NO_ICONS && !RAYGUI_CUSTOM_ICONS

// WARNING: Those values define the total size of the style data array,
// if changed, previous saved styles could become incompatible
// Maximum number of controls
// Maximum number of base properties
// Maximum number of extended properties

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
// Gui control property style color element

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
// Gui global state, if !STATE_NORMAL, forces defined state

// Gui current font (WARNING: highly coupled to raylib)
// Gui lock state (no inputs processed)
// Gui controls transparency

// Gui icon default scale (if icons enabled)

// Tooltip enabled/disabled
// Tooltip string pointer (string provided by user)

// Gui slider drag state (no inputs processed except dragged slider)
// Gui slider active bounds rectangle, used as an unique identifier

// Cursor index, shared by all GuiTextBox*()
//static int blinkCursorFrameCounter = 0;       // Frame counter for cursor blinking
// Cooldown frame counter for automatic cursor movement on key-down
// Delay frame counter for automatic cursor movement

//----------------------------------------------------------------------------------
// Style data array for all gui style properties (allocated on data segment by default)
//
// NOTE 1: First set of BASE properties are generic to all controls but could be individually
// overwritten per control, first set of EXTENDED properties are generic to all controls and
// can not be overwritten individually but custom EXTENDED properties can be used by control
//
// NOTE 2: A new style set could be loaded over this array using GuiLoadStyle(),
// but default gui style could always be recovered with GuiLoadStyleDefault()
//
// guiStyle size is by default: 16*(16 + 8) = 384*4 = 1536 bytes = 1.5 KB
//----------------------------------------------------------------------------------

// Style loaded flag for lazy style initialization

//----------------------------------------------------------------------------------
// Standalone Mode Functions Declaration
//
// NOTE: raygui depend on some raylib input and drawing functions
// To use raygui as standalone library, below functions must be defined by the user
//----------------------------------------------------------------------------------

// Input required functions
//-------------------------------------------------------------------------------

// -- GuiTextBox(), GuiValueBox()
//-------------------------------------------------------------------------------

// Drawing required functions
//-------------------------------------------------------------------------------
// -- GuiDrawRectangle()
// -- GuiColorPicker()
//-------------------------------------------------------------------------------

// Text required functions
//-------------------------------------------------------------------------------
// -- GuiLoadStyleDefault()
// -- GuiLoadStyle(), load font

// -- GuiLoadStyle(), required to load texture from embedded font atlas image
// -- GuiLoadStyle(), required to set shapes rec to font white rec (optimization)

// -- GuiLoadStyle(), required to load charset data
// -- GuiLoadStyle(), required to unload charset data

// -- GuiLoadStyle(), required to find charset/font file from text .rgs

// -- GuiLoadStyle(), required to load required font codepoints list
// -- GuiLoadStyle(), required to unload codepoints list

// -- GuiLoadStyle()
//-------------------------------------------------------------------------------

// raylib functions already implemented in raygui
//-------------------------------------------------------------------------------
// Returns a Color struct from hexadecimal value
// Returns hexadecimal value for a Color
// Check if point is inside rectangle
// Formatting of text with variables to 'embed'
// Split text into multiple strings
// Get integer value from text

// Get next codepoint in a UTF-8 encoded text
// Encode codepoint into UTF-8 text (char array size returned as parameter)

// Draw rectangle vertical gradient
//-------------------------------------------------------------------------------

// RAYGUI_STANDALONE

//----------------------------------------------------------------------------------
// Module specific Functions Declaration
//----------------------------------------------------------------------------------
// Load style from memory (binary only)

// Gui get text width using gui font and style
// Get text bounds considering control bounds
// Get text icon if provided and move text cursor

// Gui draw text using default font
// Gui draw rectangle using default raygui style

// Split controls text into multiple strings
// Convert color data from HSV to RGB
// Convert color data from RGB to HSV

// Scroll bar control, used by GuiScrollPanel()
// Draw tooltip using control rec position

// Fade color by an alpha factor

//----------------------------------------------------------------------------------
// Gui Setup Functions Definition
//----------------------------------------------------------------------------------
// Enable gui global state
// NOTE: We check for STATE_DISABLED to avoid messing custom global state setups

// Disable gui global state
// NOTE: We check for STATE_NORMAL to avoid messing custom global state setups

// Lock gui global state

// Unlock gui global state

// Check if gui is locked (global state)

// Set gui controls alpha global state

// Set gui state (global state)

// Get gui state (global state)

// Set custom gui font
// NOTE: Font loading/unloading is external to raygui

// NOTE: If we try to setup a font but default style has not been
// lazily loaded before, it will be overwritten, so we need to force
// default style loading first

// Get custom gui font

// Set control style property value

// Default properties are propagated to all controls

// Get control style property value

//----------------------------------------------------------------------------------
// Gui Controls Functions Definition
//----------------------------------------------------------------------------------

// Window Box control

// Window title bar height (including borders)
// NOTE: This define is also used by GuiMessageBox() and GuiTextInputBox()

//GuiState state = guiState;

// Update control
//--------------------------------------------------------------------
// NOTE: Logic is directly managed by button
//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// Draw window header as status bar
// Draw window base

// Draw window close button

//--------------------------------------------------------------------

// Window close button clicked: result = 1

// Group Box control with text name

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Line control

// Draw control
//--------------------------------------------------------------------

// Draw line with embedded text label: "--- text --------------"

//--------------------------------------------------------------------

// Panel control

// Text will be drawn as a header bar (if provided)

// Move panel bounds after the header bar

// Draw control
//--------------------------------------------------------------------
// Draw panel header as status bar

//--------------------------------------------------------------------

// Tab Bar control
// NOTE: Using GuiToggle() for the TABS

//GuiState state = guiState;

// Required in case tabs go out of screen

// Required for individual toggles

// Draw control
//--------------------------------------------------------------------

// Draw tabs as toggle controls

// Draw tab close button
// NOTE: Only draw close button for current tab: if (CheckCollisionPointRec(mousePosition, tabBounds))

// Draw tab-bar bottom line

//--------------------------------------------------------------------

// Return as result the current TAB closing requested

// Scroll Panel control

// Default movement speed with mouse wheel

// Text will be drawn as a header bar (if provided)

// Move panel bounds after the header bar

// Recheck to account for the other scrollbar being visible

// Make sure scroll bars have a minimum width/height
// NOTE: If content >>> bounds, size could be very small or even 0

// TODO: Calculate speed increment based on content.height vs bounds.height

// TODO: Calculate speed increment based on content.width vs bounds.width

// Calculate view area (area without the scrollbars)

// Clip view area to the actual content size

// Update control
//--------------------------------------------------------------------

// Check button state

// Horizontal and vertical scrolling with mouse wheel

// Vertical scroll

// Normalize scroll values

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// Draw panel header as status bar

// Draw background

// Save size of the scrollbar slider

// Draw horizontal scrollbar if visible

// Change scrollbar slider size to show the diff in size between the content width and the widget width

// Draw vertical scrollbar if visible

// Change scrollbar slider size to show the diff in size between the content height and the widget height

// Draw detail corner rectangle if both scroll bars are visible

// Draw scrollbar lines depending on current state

// Set scrollbar slider size back to the way it was before

//--------------------------------------------------------------------

// Label control

// Update control
//--------------------------------------------------------------------
//...
//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Button control, returns true when clicked

// Update control
//--------------------------------------------------------------------

// Check button state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//------------------------------------------------------------------

// Button pressed: result = 1

// Label button control

// NOTE: We force bounds.width to be all text

// Update control
//--------------------------------------------------------------------

// Check checkbox state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Toggle Button control, returns true when active

// Update control
//--------------------------------------------------------------------

// Check toggle button state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Toggle Group control, returns toggled button codepointIndex

// Required for individual toggles

// Get substrings items from text (items pointers)

// Toggle Slider control extended, returns true when clicked

//bool toggle = false;    // Required for individual toggles

// Get substrings items from text (items pointers)

// Calculated later depending on the active toggle

// Update control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw internal slider

// Draw text in slider

//--------------------------------------------------------------------

// Check Box control, returns true when active

// Update control
//--------------------------------------------------------------------

// Check checkbox state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Combo Box control, returns selected item codepointIndex

// Get substrings items from text (items pointers, lengths and count)

// Update control
//--------------------------------------------------------------------

// Cyclic combobox

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// Draw combo box main

// Draw selector using a custom button
// NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values

//--------------------------------------------------------------------

// Dropdown Box control
// NOTE: Returns mouse click

// Get substrings items from text (items pointers, lengths and count)

// Update control
//--------------------------------------------------------------------

// Check if mouse has been pressed or released outside limits

// Check if already selected item has been pressed again

// Check focused and selected item

// Update item rectangle y position for next item

// Item selected

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw visible items

// Update item rectangle y position for next item

// Draw arrows (using icon if available)

// ICON_ARROW_DOWN_FILL

//--------------------------------------------------------------------

// TODO: Use result to return more internal states: mouse-press out-of-bounds, mouse-press over selected-item...
// Mouse click: result = 1

// Text Box control
// NOTE: Returns true on ENTER pressed (useful for data validation)

// Frames to wait for autocursor movement

// Frames delay for autocursor movement

// TODO: Consider multiline text input

// Text index offset to start drawing in the box

// Cursor rectangle
// NOTE: Position X value should be updated

// Mouse cursor rectangle
// NOTE: Initialized outside of screen

// Auto-cursor movement logic
// NOTE: Cursor moves automatically when key down after some time

// GLOBAL: Cursor cooldown counter
// GLOBAL: Cursor delay counter

// Blink-cursor frame counter
//if (!autoCursorMode) blinkCursorFrameCounter++;
//else blinkCursorFrameCounter = 0;

// Update control
//--------------------------------------------------------------------
// WARNING: Text editing is only supported under certain conditions:
// Control not disabled
// TextBox not on read-only mode
// Gui not locked
// No gui slider on dragging
// No wrap mode

// If text does not fit in the textbox and current cursor position is out of bounds,
// we add an index offset to text for drawing only what requires depending on cursor

// Get current text length
// Get Unicode codepoint

// Encode codepoint as UTF-8

// Add codepoint to text, at current cursor position
// NOTE: Make sure we do not overflow buffer size

// Move forward data from cursor position

// Add new codepoint in current cursor position

// Make sure text last character is EOL

// Move cursor to start

// Move cursor to end

// Delete codepoint from text, after current cursor position

// Delay every movement some frames

// Move backward text from cursor position

// Make sure text last character is EOL

// Delete codepoint from text, before current cursor position

// Delay every movement some frames

// Move backward text from cursor position

// Prevent cursor index from decrementing past 0

// Make sure text last character is EOL

// Move cursor position with keys

// Delay every movement some frames

// Delay every movement some frames

// Move cursor position with mouse
// Mouse hover text

// Check if mouse cursor is at the last position

// Place cursor at required index on mouse click

// Recalculate cursor position.y depending on textBoxCursorIndex

//if (multiline) cursor.y = GetTextLines()

// Finish text editing on ENTER or mouse click outside bounds

// GLOBAL: Reset the shared cursor index

// GLOBAL: Place cursor index to the end of current text

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw text considering index offset if required
// NOTE: Text index offset depends on cursor position

// Draw cursor

//if (autoCursorMode || ((blinkCursorFrameCounter/40)%2 == 0))

// Draw mouse position cursor (if required)

//--------------------------------------------------------------------

// Mouse button pressed: result = 1

/*
// Text Box control with multiple lines and word-wrap
// NOTE: This text-box is readonly, no editing supported by default
bool GuiTextBoxMulti(Rectangle bounds, char *text, int bufferSize, bool editMode)
{
    bool pressed = false;

    GuiSetStyle(TEXTBOX, TEXT_READONLY, 1);
    GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD);   // WARNING: If wrap mode enabled, text editing is not supported
    GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP);

    // TODO: Implement methods to calculate cursor position properly
    pressed = GuiTextBox(bounds, text, bufferSize, editMode);

    GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE);
    GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE);
    GuiSetStyle(TEXTBOX, TEXT_READONLY, 0);

    return pressed;
}
*/

// Spinner control, returns selected value

// Update control
//--------------------------------------------------------------------

// Check spinner state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw value selector custom buttons
// NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values

// Draw text label if provided

//--------------------------------------------------------------------

// Value Box control, updates input text with numbers
// NOTE: Requires static variables: frameCounter

// Update control
//--------------------------------------------------------------------

// Only allow keys in range [48..57]

// Delete text

// NOTE: We are not clamp values until user input finishes
//if (*value > maxValue) *value = maxValue;
//else if (*value < minValue) *value = minValue;

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw cursor

// NOTE: ValueBox internal text is always centered

// Draw text label if provided

//--------------------------------------------------------------------

// Slider control with pro parameters
// NOTE: Other GuiSlider*() controls use this one

// Slider

// SliderBar

// Update control
//--------------------------------------------------------------------

// Keep dragging outside of bounds

// Get equivalent value and slider position from mousePosition.x

// Store bounds as an identifier when dragging starts

// Get equivalent value and slider position from mousePosition.x

// Slider
// SliderBar

// Bar limits check
// Slider

// SliderBar

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw slider internal bar (depends on state)

// Draw left/right text if provided

//--------------------------------------------------------------------

// Slider control extended, returns selected value and has text

// Slider Bar control extended, returns selected value

// Progress Bar control extended, shows current progress value

// Progress bar

// Update control
//--------------------------------------------------------------------

// WARNING: Working with floats could lead to rounding issues

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw progress bar with colored border, more visual

// Draw borders not yet reached by value

// Draw slider internal progress bar (depends on state)

// Draw left/right text if provided

//--------------------------------------------------------------------

// Status Bar control

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Dummy rectangle control, intended for placeholding

// Update control
//--------------------------------------------------------------------

// Check button state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//------------------------------------------------------------------

// List View control

// List View control with extended parameters

// Check if we need a scroll bar

// Define base item rectangle [0]

// Get items on the list

// Update control
//--------------------------------------------------------------------

// Check mouse inside list view

// Check focused and selected item

// Update item rectangle y position for next item

// Reset item rectangle y to [0]

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// Draw background

// Draw visible items

// Draw item selected

// && (focus != NULL))  // NOTE: We want items focused, despite not returned!

// Draw item focused

// Draw item normal

// Update item rectangle y position for next item

// Calculate percentage of visible items and apply same percentage to scrollbar

// Save default slider size
// Save default scroll speed
// Change slider size
// Change scroll speed

// Reset scroll speed to default
// Reset slider size to default

//--------------------------------------------------------------------

// Color Panel control

// HSV: Saturation
// HSV: Value

// Update control
//--------------------------------------------------------------------

// Calculate color from picker

// Get normalized value on x
// Get normalized value on y

// NOTE: Vector3ToColor() only available on raylib 1.8.1

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw color picker: selector

//--------------------------------------------------------------------

// Color Bar Alpha control
// NOTE: Returns alpha value normalized [0..1]

// Update control
//--------------------------------------------------------------------

// Keep dragging outside of bounds

// Store bounds as an identifier when dragging starts

//selector.x = bounds.x + (int)(((alpha - 0)/(100 - 0))*(bounds.width - 2*GuiGetStyle(SLIDER, BORDER_WIDTH))) - selector.width/2;

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw alpha bar: checked background

// Draw alpha bar: selector

//--------------------------------------------------------------------

// Color Bar Hue control
// Returns hue value normalized [0..1]
// NOTE: Other similar bars (for reference):
//      Color GuiColorBarSat() [WHITE->color]
//      Color GuiColorBarValue() [BLACK->color], HSV/HSL
//      float GuiColorBarLuminance() [BLACK->WHITE]

// Update control
//--------------------------------------------------------------------

// Keep dragging outside of bounds

// Store bounds as an identifier when dragging starts

/*if (IsKeyDown(KEY_UP))
{
    hue -= 2.0f;
    if (hue <= 0.0f) hue = 0.0f;
}
else if (IsKeyDown(KEY_DOWN))
{
    hue += 2.0f;
    if (hue >= 360.0f) hue = 360.0f;
}*/

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw hue bar:color bars
// TODO: Use directly DrawRectangleGradientEx(bounds, color1, color2, color2, color1);

// Draw hue bar: selector

//--------------------------------------------------------------------

// Color Picker control
// NOTE: It's divided in multiple controls:
//      Color GuiColorPanel(Rectangle bounds, Color color)
//      float GuiColorBarAlpha(Rectangle bounds, float alpha)
//      float GuiColorBarHue(Rectangle bounds, float value)
// NOTE: bounds define GuiColorPanel() size

//Rectangle boundsAlpha = { bounds.x, bounds.y + bounds.height + GuiGetStyle(COLORPICKER, BARS_PADDING), bounds.width, GuiGetStyle(COLORPICKER, BARS_THICK) };

//color.a = (unsigned char)(GuiColorBarAlpha(boundsAlpha, (float)color.a/255.0f)*255.0f);

// Color Picker control that avoids conversion to RGB and back to HSV on each call, thus avoiding jittering.
// The user can call ConvertHSVtoRGB() to convert *colorHsv value to RGB.
// NOTE: It's divided in multiple controls:
//      int GuiColorPanelHSV(Rectangle bounds, const char *text, Vector3 *colorHsv)
//      int GuiColorBarAlpha(Rectangle bounds, const char *text, float *alpha)
//      float GuiColorBarHue(Rectangle bounds, float value)
// NOTE: bounds define GuiColorPanelHSV() size

// Color Panel control, returns HSV color value in *colorHsv.
// Used by GuiColorPickerHSV()

// HSV: Saturation
// HSV: Value

// Update control
//--------------------------------------------------------------------

// Calculate color from picker

// Get normalized value on x
// Get normalized value on y

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw color picker: selector

//--------------------------------------------------------------------

// Message Box control

// Returns clicked button from buttons list, 0 refers to closed window button

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Text Input Box control, ask for text

// Used to enable text edit mode
// WARNING: No more than one GuiTextInputBox() should be open at the same time

// Draw control
//--------------------------------------------------------------------

// Draw message if available

//--------------------------------------------------------------------

// Result is the pressed button index

// Grid control
// NOTE: Returns grid mouse-hover selected cell
// About drawing lines at subpixel spacing, simple put, not easy solution:
// https://stackoverflow.com/questions/4435450/2d-opengl-drawing-lines-that-dont-exactly-fit-pixel-raster

// Grid lines alpha amount

// Update control
//--------------------------------------------------------------------

// NOTE: Cell values must be the upper left of the cell the mouse is in

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw vertical grid lines

// Draw horizontal grid lines

//----------------------------------------------------------------------------------
// Tooltip management functions
// NOTE: Tooltips requires some global variables: tooltipPtr
//----------------------------------------------------------------------------------
// Enable gui tooltips (global state)

// Disable gui tooltips (global state)

// Set tooltip string

//----------------------------------------------------------------------------------
// Styles loading functions
//----------------------------------------------------------------------------------

// Load raygui style file (.rgs)
// NOTE: By default a binary file is expected, that file could contain a custom font,
// in that case, custom font image atlas is GRAY+ALPHA and pixel data can be compressed (DEFLATE)

// Try reading the files as text file first

// Style property: p <control_id> <property_id> <property_value> <property_name>

// Style font: f <gen_font_size> <charmap_file> <font_file>

// Load text data from file
// NOTE: Expected an UTF-8 array of codepoints, no separation

// In case a font is already loaded and it is not default internal font, unload it

// Default to 95 standard codepoints

// If font texture not properly loaded, revert to default font and size/spacing

// Load style default over global style

// We set this variable first to avoid cyclic function calls
// when calling GuiSetStyle() and GuiGetStyle()

// Initialize default LIGHT style property values
// WARNING: Default value are applied to all controls on set but
// they can be overwritten later on for every custom control

// Initialize default extended property values
// NOTE: By default, extended property values are initialized to 0
// DEFAULT, shared by all controls
// DEFAULT, shared by all controls
// DEFAULT specific property
// DEFAULT specific property
// DEFAULT, 15 pixels between lines
// DEFAULT, text aligned vertically to middle of text-bounds

// Initialize control-specific property values
// NOTE: Those properties are in default list but require specific values by control type

// Initialize extended property values
// NOTE: By default, extended property values are initialized to 0

// Unload previous font texture

// Setup default raylib font

// NOTE: Default raylib font character 95 is a white square

// NOTE: We set up a 1px padding on char rectangle to avoid pixel bleeding on MSAA filtering

// Get text with icon id prepended
// NOTE: Useful to add icons by name id (enum) instead of
// a number that can change between ricon versions

// Get full icons data pointer

// Load raygui icons file (.rgi)
// NOTE: In case nameIds are required, they can be requested with loadIconsName,
// they are returned as a guiIconsName[iconCount][RAYGUI_ICON_MAX_NAME_LENGTH],
// WARNING: guiIconsName[]][] memory should be manually freed!

// Style File Structure (.rgi)
// ------------------------------------------------------
// Offset  | Size    | Type       | Description
// ------------------------------------------------------
// 0       | 4       | char       | Signature: "rGI "
// 4       | 2       | short      | Version: 100
// 6       | 2       | short      | reserved

// 8       | 2       | short      | Num icons (N)
// 10      | 2       | short      | Icons size (Options: 16, 32, 64) (S)

// Icons name id (32 bytes per name id)
// foreach (icon)
// {
//   12+32*i  | 32   | char       | Icon NameId
// }

// Icons data: One bit per pixel, stored as unsigned int array (depends on icon size)
// S*S pixels/32bit per unsigned int = K unsigned int per icon
// foreach (icon)
// {
//   ...   | K       | unsigned int | Icon Data
// }

// Read icons data directly over internal icons array

// Draw selected icon using rectangles pixel-by-pixel

// Set icon drawing size

// !RAYGUI_NO_ICONS

//----------------------------------------------------------------------------------
// Module specific Functions Definition
//----------------------------------------------------------------------------------

// Load style from memory
// WARNING: Binary files only

// DEFAULT control

// If a DEFAULT property is loaded, it is propagated to all controls
// NOTE: All DEFAULT properties should be defined first in the file

// Font loading is highly dependant on raylib API to load font data and image

// Load custom font if available

// 0-Normal, 1-SDF

// Load font white rectangle

// Load font image parameters

// Compressed font atlas image data (DEFLATE), it requires DecompressData()

// Security check, dataUncompSize must match the provided fontImageUncompSize

// Font atlas image data is not compressed

// Validate font atlas texture was loaded correctly

// Load font recs data

// WARNING: Version 400 adds the compression size parameter

// RGS files version 400 support compressed recs data

// Recs data is compressed, uncompress it

// Security check, data uncompressed size must match the expected original data size

// Recs data is uncompressed

// Load font glyphs info data
// 16 bytes data per glyph

// WARNING: Version 400 adds the compression size parameter

// RGS files version 400 support compressed glyphs data

// Allocate required glyphs space to fill with data

// Glyphs data is compressed, uncompress it

// Security check, data uncompressed size must match the expected original data size

// Glyphs data is uncompressed

// Fallback in case of errors loading font atlas texture

// Set font texture source rectangle to be used as white texture to draw shapes
// NOTE: It makes possible to draw shapes and text (full UI) in a single draw call

// Gui get text width considering icon

// Make sure guiFont is set, GuiGetStyle() initializes it lazynessly

// Custom MeasureText() implementation

// Get size in bytes of text, considering end of line and line break

// Get text bounds considering control bounds

// NOTE: Text is processed line per line!

// Depending on control, TEXT_PADDING and TEXT_ALIGNMENT properties could affect the text-bounds

// TODO: Special cases (no label): COMBOBOX, DROPDOWNBOX, LISTVIEW

// TODO: More special cases (label on side): SLIDER, CHECKBOX, VALUEBOX, SPINNER

// TODO: WARNING: TEXT_ALIGNMENT is already considered in GuiDrawText()

// Get text icon if provided and move text cursor
// NOTE: We support up to 999 values for iconId

// Maybe we have an icon!

// Maximum length for icon value: 3 digits + '\0'

// Move text pointer after icon
// WARNING: If only icon provided, it could point to EOL character: '\0'

// Get text divided into lines (by line-breaks '\n')

// Init NULL pointers to substrings

//int lineSize = 0;   // Stores current line size, not returned

//lineSize = len;

// WARNING: next value is valid?

//lines[*count - 1].size = len;

// Get text width to next space for provided string

// Gui draw text using default font

// Vertical alignment for pixel perfect

// Security check

// PROCEDURE:
//   - Text is processed line per line
//   - For every line, horizontal alignment is defined
//   - For all text, vertical alignment is defined (multiline text only)
//   - For every line, wordwrap mode is checked (useful for GuitextBox(), read-only)

// Get text lines (using '\n' as delimiter) to be processed individually
// WARNING: We can't use GuiTextSplit() function because it can be already used
// before the GuiDrawText() call and its buffer is static, it would be overriden :(

// Text style variables
//int alignment = GuiGetStyle(DEFAULT, TEXT_ALIGNMENT);

// Wrap-mode only available in read-only mode, no for text editing

// TODO: WARNING: This totalHeight is not valid for vertical alignment in case of word-wrap

// Check text for icon and move cursor

// Get text position depending on alignment and iconId
//---------------------------------------------------------------------------------

// NOTE: We get text size after icon has been processed
// WARNING: GetTextWidth() also processes text icon to get width! -> Really needed?

// If text requires an icon, add size to measure

// WARNING: If only icon provided, text could be pointing to EOF character: '\0'

// Check guiTextAlign global variables

// Only valid in case of wordWrap = 0;

// NOTE: Make sure we get pixel-perfect coordinates,
// In case of decimals we got weird text positioning

//---------------------------------------------------------------------------------

// Draw text (with icon if available)
//---------------------------------------------------------------------------------

// NOTE: We consider icon height, probably different than text size

// Get size in bytes of text,
// considering end of line and line break

// NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
// but we need to draw all of the bad bytes using the '?' symbol moving one byte
// TODO: Review not recognized codepoints size

// Wrap mode text measuring to space to validate if it can be drawn or
// a new line is required

// Get glyph width to check if it goes out of bounds

// Jump to next line if current character reach end of the box limits

// Get width to next space in line

// TODO: Consider case: (nextSpaceWidth >= textBounds.width)

// WARNING: Lines are already processed manually, no need to keep drawing after this codepoint

// TODO: There are multiple types of spaces in Unicode, 
// maybe it's a good idea to add support for more: http://jkorpela.fi/chars/spaces.html
// Do not draw codepoints with no glyph

// Draw only required text glyphs fitting the textBounds.width

// Draw only glyphs inside the bounds

//---------------------------------------------------------------------------------

// Gui draw rectangle using default raygui plain style with borders

// Draw rectangle filled with color

// Draw rectangle border lines with color

// Draw tooltip using control bounds

// Split controls text into multiple strings
// Also check for multiple columns (required by GuiToggleGroup())

// NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
// inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
// all used memory is static... it has some limitations:
//      1. Maximum number of possible split strings is set by RAYGUI_TEXTSPLIT_MAX_ITEMS
//      2. Maximum size of text to split is RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE
// NOTE: Those definitions could be externally provided if required

// TODO: HACK: GuiTextSplit() - Review how textRows are returned to user
// textRow is an externally provided array of integers that stores row number for every splitted string

// String pointers array (points to buffer data)
// Buffer data (text input copy with '\0' added)

// Count how many substrings we have on text and point to every one

// Set an end of string at this point

// Convert color data from RGB to HSV
// NOTE: Color data should be passed normalized

// Value

// Undefined, maybe NAN?

// NOTE: If max is 0, this divide would cause a crash
// Saturation

// NOTE: If max is 0, then r = g = b = 0, s = 0, h is undefined

// Undefined, maybe NAN?

// NOTE: Comparing float values could not work properly
// Between yellow & magenta

// Between cyan & yellow
// Between magenta & cyan

// Convert to degrees

// Convert color data from HSV to RGB
// NOTE: Color data should be passed normalized

// NOTE: Comparing float values could not work properly

// Scroll bar control (used by GuiScrollPanel())

// Is the scrollbar horizontal or vertical?

// The size (width or height depending on scrollbar type) of the spinner buttons

// Arrow buttons [<] [>] [∧] [∨]

// Actual area of the scrollbar excluding the arrow buttons

// Slider bar that moves     --[///]-----

// Normalize value

// Calculate rectangles for all of the components

// Make sure the slider won't get outside of the scrollbar

// horizontal

// Make sure the slider won't get outside of the scrollbar

// Update control
//--------------------------------------------------------------------

// Keep dragging outside of bounds

// Handle mouse wheel

// Handle mouse button down

// Store bounds as an identifier when dragging starts

// Check arrows click

// If click on scrollbar position but not on slider, place slider directly on that position

// Keyboard control on mouse hover scrollbar
/*
if (isVertical)
{
    if (IsKeyDown(KEY_DOWN)) value += 5;
    else if (IsKeyDown(KEY_UP)) value -= 5;
}
else
{
    if (IsKeyDown(KEY_RIGHT)) value += 5;
    else if (IsKeyDown(KEY_LEFT)) value -= 5;
}
*/

// Normalize value

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// Draw the background

// Draw the scrollbar active area background
// Draw the slider bar

// Draw arrows (using icon if available)

// ICON_ARROW_UP_FILL / ICON_ARROW_LEFT_FILL

// ICON_ARROW_DOWN_FILL / ICON_ARROW_RIGHT_FILL

//--------------------------------------------------------------------

// Color fade-in or fade-out, alpha goes from 0.0f to 1.0f
// WARNING: It multiplies current alpha by alpha scale factor

// Returns a Color struct from hexadecimal value

// Returns hexadecimal value for a Color

// Check if point is inside rectangle

// Formatting of text with variables to 'embed'

// Draw rectangle with vertical gradient fill color
// NOTE: This function is only used by GuiColorPicker()

// Split string into multiple strings

// NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
// inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
// all used memory is static... it has some limitations:
//      1. Maximum number of possible split strings is set by RAYGUI_TEXTSPLIT_MAX_ITEMS
//      2. Maximum size of text to split is RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE

// Count how many substrings we have on text and point to every one

// Set an end of string at this point

// Get integer value from text
// NOTE: This function replaces atoi() [stdlib.h]

// Encode codepoint into UTF-8 text (char array size returned as parameter)

// Get next codepoint in a UTF-8 encoded text, scanning until '\0' is found
// When a invalid UTF-8 byte is encountered we exit as soon as possible and a '?'(0x3f) codepoint is returned
// Total number of bytes processed are returned as a parameter
// NOTE: the standard says U+FFFD should be returned in case of errors
// but that character is not supported by the default font in raylib

// Codepoint (defaults to '?')

// Get current codepoint and bytes processed

// 4 byte UTF-8 codepoint
//10xxxxxx checks

// 3 byte UTF-8 codepoint */
//10xxxxxx checks

// 2 byte UTF-8 codepoint
//10xxxxxx checks

// 1 byte UTF-8 codepoint

// RAYGUI_STANDALONE

// RAYGUI_IMPLEMENTATION
