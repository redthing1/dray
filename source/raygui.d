/*******************************************************************************************
*
*   raygui v3.2 - A simple and easy-to-use immediate-mode gui library
*
*   DESCRIPTION:
*
*   raygui is a tools-dev-focused immediate-mode-gui library based on raylib but also
*   available as a standalone library, as long as input and drawing functions are provided.
*
*   Controls provided:
*
*   # Container/separators Controls
*       - WindowBox     --> StatusBar, Panel
*       - GroupBox      --> Line
*       - Line
*       - Panel         --> StatusBar
*       - ScrollPanel   --> StatusBar
*
*   # Basic Controls
*       - Label
*       - Button
*       - LabelButton   --> Label
*       - Toggle
*       - ToggleGroup   --> Toggle
*       - CheckBox
*       - ComboBox
*       - DropdownBox
*       - TextBox
*       - TextBoxMulti
*       - ValueBox      --> TextBox
*       - Spinner       --> Button, ValueBox
*       - Slider
*       - SliderBar     --> Slider
*       - ProgressBar
*       - StatusBar
*       - DummyRec
*       - Grid
*
*   # Advance Controls
*       - ListView
*       - ColorPicker   --> ColorPanel, ColorBarHue
*       - MessageBox    --> Window, Label, Button
*       - TextInputBox  --> Window, Label, TextBox, Button
*
*   It also provides a set of functions for styling the controls based on its properties (size, color).
*
*
*   RAYGUI STYLE (guiStyle):
*
*   raygui uses a global data array for all gui style properties (allocated on data segment by default),
*   when a new style is loaded, it is loaded over the global style... but a default gui style could always be
*   recovered with GuiLoadStyleDefault() function, that overwrites the current style to the default one
*
*   The global style array size is fixed and depends on the number of controls and properties:
*
*       static unsigned int guiStyle[RAYGUI_MAX_CONTROLS*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED)];
*
*   guiStyle size is by default: 16*(16 + 8) = 384*4 = 1536 bytes = 1.5 KB
*
*   Note that the first set of BASE properties (by default guiStyle[0..15]) belong to the generic style
*   used for all controls, when any of those base values is set, it is automatically populated to all
*   controls, so, specific control values overwriting generic style should be set after base values.
*
*   After the first BASE set we have the EXTENDED properties (by default guiStyle[16..23]), those
*   properties are actually common to all controls and can not be overwritten individually (like BASE ones)
*   Some of those properties are: TEXT_SIZE, TEXT_SPACING, LINE_COLOR, BACKGROUND_COLOR
*
*   Custom control properties can be defined using the EXTENDED properties for each independent control.
*
*   TOOL: rGuiStyler is a visual tool to customize raygui style.
*
*
*   RAYGUI ICONS (guiIcons):
*
*   raygui could use a global array containing icons data (allocated on data segment by default),
*   a custom icons set could be loaded over this array using GuiLoadIcons(), but loaded icons set
*   must be same RAYGUI_ICON_SIZE and no more than RAYGUI_ICON_MAX_ICONS will be loaded
*
*   Every icon is codified in binary form, using 1 bit per pixel, so, every 16x16 icon
*   requires 8 integers (16*16/32) to be stored in memory.
*
*   When the icon is draw, actually one quad per pixel is drawn if the bit for that pixel is set.
*
*   The global icons array size is fixed and depends on the number of icons and size:
*
*       static unsigned int guiIcons[RAYGUI_ICON_MAX_ICONS*RAYGUI_ICON_DATA_ELEMENTS];
*
*   guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
*
*   TOOL: rGuiIcons is a visual tool to customize raygui icons.
*
*
*   CONFIGURATION:
*
*   #define RAYGUI_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers
*       or source files without problems. But only ONE file should hold the implementation.
*
*   #define RAYGUI_STANDALONE
*       Avoid raylib.h header inclusion in this file. Data types defined on raylib are defined
*       internally in the library and input management and drawing functions must be provided by
*       the user (check library implementation for further details).
*
*   #define RAYGUI_NO_ICONS
*       Avoid including embedded ricons data (256 icons, 16x16 pixels, 1-bit per pixel, 2KB)
*
*   #define RAYGUI_CUSTOM_ICONS
*       Includes custom ricons.h header defining a set of custom icons,
*       this file can be generated using rGuiIcons tool
*
*
*   VERSIONS HISTORY:
*       3.2 (22-May-2022) RENAMED: Some enum values, for unification, avoiding prefixes
*                         REMOVED: GuiScrollBar(), only internal
*                         REDESIGNED: GuiPanel() to support text parameter
*                         REDESIGNED: GuiScrollPanel() to support text parameter
*                         REDESIGNED: GuiColorPicker() to support text parameter
*                         REDESIGNED: GuiColorPanel() to support text parameter
*                         REDESIGNED: GuiColorBarAlpha() to support text parameter
*                         REDESIGNED: GuiColorBarHue() to support text parameter
*                         REDESIGNED: GuiTextInputBox() to support password
*       3.1 (12-Jan-2022) REVIEWED: Default style for consistency (aligned with rGuiLayout v2.5 tool)
*                         REVIEWED: GuiLoadStyle() to support compressed font atlas image data and unload previous textures
*                         REVIEWED: External icons usage logic
*                         REVIEWED: GuiLine() for centered alignment when including text
*                         RENAMED: Multiple controls properties definitions to prepend RAYGUI_
*                         RENAMED: RICON_ references to RAYGUI_ICON_ for library consistency
*                         Projects updated and multiple tweaks
*       3.0 (04-Nov-2021) Integrated ricons data to avoid external file
*                         REDESIGNED: GuiTextBoxMulti()
*                         REMOVED: GuiImageButton*()
*                         Multiple minor tweaks and bugs corrected
*       2.9 (17-Mar-2021) REMOVED: Tooltip API
*       2.8 (03-May-2020) Centralized rectangles drawing to GuiDrawRectangle()
*       2.7 (20-Feb-2020) ADDED: Possible tooltips API
*       2.6 (09-Sep-2019) ADDED: GuiTextInputBox()
*                         REDESIGNED: GuiListView*(), GuiDropdownBox(), GuiSlider*(), GuiProgressBar(), GuiMessageBox()
*                         REVIEWED: GuiTextBox(), GuiSpinner(), GuiValueBox(), GuiLoadStyle()
*                         Replaced property INNER_PADDING by TEXT_PADDING, renamed some properties
*                         ADDED: 8 new custom styles ready to use
*                         Multiple minor tweaks and bugs corrected
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
*
*   CONTRIBUTORS:
*
*       Ramon Santamaria:   Supervision, review, redesign, update and maintenance
*       Vlad Adrian:        Complete rewrite of GuiTextBox() to support extended features (2019)
*       Sergio Martinez:    Review, testing (2015) and redesign of multiple controls (2018)
*       Adria Arranz:       Testing and Implementation of additional controls (2018)
*       Jordi Jorba:        Testing and Implementation of additional controls (2018)
*       Albert Martos:      Review and testing of the library (2015)
*       Ian Eito:           Review and testing of the library (2015)
*       Kevin Gato:         Initial implementation of basic components (2014)
*       Daniel Nicolas:     Initial implementation of basic components (2014)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
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

enum RAYGUI_VERSION = "3.2";

// Function specifiers in case library is build/used as a shared library (Windows)
// NOTE: Microsoft specifiers to tell compiler that symbols are imported/exported from a .dll

// We are building the library as a Win32 shared library (.dll)

// We are using the library as a Win32 shared library (.dll)

// Function specifiers definition // Functions defined as 'extern' by default (implicit specifiers)

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------

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

// GlyphInfo, font characters glyphs info

// Character value (Unicode)
// Character offset X when drawing
// Character offset Y when drawing
// Character advance position X
// Character image data

// TODO: Font type is very coupled to raylib, mostly required by GuiLoadStyle()
// It should be redesigned to be provided by user

// Base size (default chars height)
// Number of characters
// Characters texture atlas
// Characters rectangles in texture
// Characters info data

// Style property
struct GuiStyleProp
{
    ushort controlId;
    ushort propertyId;
    uint propertyValue;
}

// Gui control state
enum GuiState
{
    STATE_NORMAL = 0,
    STATE_FOCUSED = 1,
    STATE_PRESSED = 2,
    STATE_DISABLED = 3
}

// Gui control text alignment
enum GuiTextAlignment
{
    TEXT_ALIGN_LEFT = 0,
    TEXT_ALIGN_CENTER = 1,
    TEXT_ALIGN_RIGHT = 2
}

// Gui controls
enum GuiControl
{
    // Default -> populates to all controls when set
    DEFAULT = 0,
    // Basic controls
    LABEL = 1, // Used also for: LABELBUTTON
    BUTTON = 2,
    TOGGLE = 3, // Used also for: TOGGLEGROUP
    SLIDER = 4, // Used also for: SLIDERBAR
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

// Gui base properties for every control
// NOTE: RAYGUI_MAX_PROPS_BASE properties (by default 16 properties)
enum GuiControlProperty
{
    BORDER_COLOR_NORMAL = 0,
    BASE_COLOR_NORMAL = 1,
    TEXT_COLOR_NORMAL = 2,
    BORDER_COLOR_FOCUSED = 3,
    BASE_COLOR_FOCUSED = 4,
    TEXT_COLOR_FOCUSED = 5,
    BORDER_COLOR_PRESSED = 6,
    BASE_COLOR_PRESSED = 7,
    TEXT_COLOR_PRESSED = 8,
    BORDER_COLOR_DISABLED = 9,
    BASE_COLOR_DISABLED = 10,
    TEXT_COLOR_DISABLED = 11,
    BORDER_WIDTH = 12,
    TEXT_PADDING = 13,
    TEXT_ALIGNMENT = 14,
    RESERVED = 15
}

// Gui extended properties depend on control
// NOTE: RAYGUI_MAX_PROPS_EXTENDED properties (by default 8 properties)
//----------------------------------------------------------------------------------

// DEFAULT extended properties
// NOTE: Those properties are common to all controls or global
enum GuiDefaultProperty
{
    TEXT_SIZE = 16, // Text size (glyphs max height)
    TEXT_SPACING = 17, // Text spacing between glyphs
    LINE_COLOR = 18, // Line control color
    BACKGROUND_COLOR = 19 // Background color
}

// Label
//typedef enum { } GuiLabelProperty;

// Button/Spinner
//typedef enum { } GuiButtonProperty;

// Toggle/ToggleGroup
enum GuiToggleProperty
{
    GROUP_PADDING = 16 // ToggleGroup separation between toggles
}

// Slider/SliderBar
enum GuiSliderProperty
{
    SLIDER_WIDTH = 16, // Slider size of internal bar
    SLIDER_PADDING = 17 // Slider/SliderBar internal bar padding
}

// ProgressBar
enum GuiProgressBarProperty
{
    PROGRESS_PADDING = 16 // ProgressBar internal padding
}

// ScrollBar
enum GuiScrollBarProperty
{
    ARROWS_SIZE = 16,
    ARROWS_VISIBLE = 17,
    SCROLL_SLIDER_PADDING = 18, // (SLIDERBAR, SLIDER_PADDING)
    SCROLL_SLIDER_SIZE = 19,
    SCROLL_PADDING = 20,
    SCROLL_SPEED = 21
}

// CheckBox
enum GuiCheckBoxProperty
{
    CHECK_PADDING = 16 // CheckBox internal check padding
}

// ComboBox
enum GuiComboBoxProperty
{
    COMBO_BUTTON_WIDTH = 16, // ComboBox right button width
    COMBO_BUTTON_SPACING = 17 // ComboBox button separation
}

// DropdownBox
enum GuiDropdownBoxProperty
{
    ARROW_PADDING = 16, // DropdownBox arrow separation from border and items
    DROPDOWN_ITEMS_SPACING = 17 // DropdownBox items separation
}

// TextBox/TextBoxMulti/ValueBox/Spinner
enum GuiTextBoxProperty
{
    TEXT_INNER_PADDING = 16, // TextBox/TextBoxMulti/ValueBox/Spinner inner text padding
    TEXT_LINES_SPACING = 17 // TextBoxMulti lines separation
}

// Spinner
enum GuiSpinnerProperty
{
    SPIN_BUTTON_WIDTH = 16, // Spinner left/right buttons width
    SPIN_BUTTON_SPACING = 17 // Spinner buttons separation
}

// ListView
enum GuiListViewProperty
{
    LIST_ITEMS_HEIGHT = 16, // ListView items height
    LIST_ITEMS_SPACING = 17, // ListView items separation
    SCROLLBAR_WIDTH = 18, // ListView scrollbar size (usually width)
    SCROLLBAR_SIDE = 19 // ListView scrollbar side (0-left, 1-right)
}

// ColorPicker
enum GuiColorPickerProperty
{
    COLOR_SELECTOR_SIZE = 16,
    HUEBAR_WIDTH = 17, // ColorPicker right hue bar width
    HUEBAR_PADDING = 18, // ColorPicker right hue bar separation from panel
    HUEBAR_SELECTOR_HEIGHT = 19, // ColorPicker right hue bar selector height
    HUEBAR_SELECTOR_OVERFLOW = 20 // ColorPicker right hue bar selector overflow
}

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
void GuiFade (float alpha); // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
void GuiSetState (int state); // Set gui state (global state)
int GuiGetState (); // Get gui state (global state)

// Font set/get functions
void GuiSetFont (Font font); // Set gui custom font (global state)
Font GuiGetFont (); // Get gui custom font (global state)

// Style set/get functions
void GuiSetStyle (int control, int property, int value); // Set one style property
int GuiGetStyle (int control, int property); // Get one style property

// Container/separator controls, useful for controls organization
bool GuiWindowBox (Rectangle bounds, const(char)* title); // Window Box control, shows a window that can be closed
void GuiGroupBox (Rectangle bounds, const(char)* text); // Group Box control with text name
void GuiLine (Rectangle bounds, const(char)* text); // Line separator control, could contain text
void GuiPanel (Rectangle bounds, const(char)* text); // Panel control, useful to group controls
Rectangle GuiScrollPanel (Rectangle bounds, const(char)* text, Rectangle content, Vector2* scroll); // Scroll Panel control

// Basic controls set
void GuiLabel (Rectangle bounds, const(char)* text); // Label control, shows text
bool GuiButton (Rectangle bounds, const(char)* text); // Button control, returns true when clicked
bool GuiLabelButton (Rectangle bounds, const(char)* text); // Label button control, show true when clicked
bool GuiToggle (Rectangle bounds, const(char)* text, bool active); // Toggle Button control, returns true when active
int GuiToggleGroup (Rectangle bounds, const(char)* text, int active); // Toggle Group control, returns active toggle index
bool GuiCheckBox (Rectangle bounds, const(char)* text, bool checked); // Check Box control, returns true when active
int GuiComboBox (Rectangle bounds, const(char)* text, int active); // Combo Box control, returns selected item index
bool GuiDropdownBox (Rectangle bounds, const(char)* text, int* active, bool editMode); // Dropdown Box control, returns selected item
bool GuiSpinner (Rectangle bounds, const(char)* text, int* value, int minValue, int maxValue, bool editMode); // Spinner control, returns selected value
bool GuiValueBox (Rectangle bounds, const(char)* text, int* value, int minValue, int maxValue, bool editMode); // Value Box control, updates input text with numbers
bool GuiTextBox (Rectangle bounds, char* text, int textSize, bool editMode); // Text Box control, updates input text
bool GuiTextBoxMulti (Rectangle bounds, char* text, int textSize, bool editMode); // Text Box control with multiple lines
float GuiSlider (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float value, float minValue, float maxValue); // Slider control, returns selected value
float GuiSliderBar (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float value, float minValue, float maxValue); // Slider Bar control, returns selected value
float GuiProgressBar (Rectangle bounds, const(char)* textLeft, const(char)* textRight, float value, float minValue, float maxValue); // Progress Bar control, shows current progress value
void GuiStatusBar (Rectangle bounds, const(char)* text); // Status Bar control, shows info text
void GuiDummyRec (Rectangle bounds, const(char)* text); // Dummy control for placeholders
Vector2 GuiGrid (Rectangle bounds, const(char)* text, float spacing, int subdivs); // Grid control, returns mouse cell position

// Advance controls set
int GuiListView (Rectangle bounds, const(char)* text, int* scrollIndex, int active); // List View control, returns selected list item index
int GuiListViewEx (Rectangle bounds, const(char*)* text, int count, int* focus, int* scrollIndex, int active); // List View with extended parameters
int GuiMessageBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons); // Message Box control, displays a message
int GuiTextInputBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons, char* text, int textMaxSize, int* secretViewActive); // Text Input Box control, ask for text, supports secret
Color GuiColorPicker (Rectangle bounds, const(char)* text, Color color); // Color Picker control (multiple color controls)
Color GuiColorPanel (Rectangle bounds, const(char)* text, Color color); // Color Panel control
float GuiColorBarAlpha (Rectangle bounds, const(char)* text, float alpha); // Color Bar Alpha control
float GuiColorBarHue (Rectangle bounds, const(char)* text, float value); // Color Bar Hue control

// Styles loading functions
void GuiLoadStyle (const(char)* fileName); // Load style file over global style variable (.rgs)
void GuiLoadStyleDefault (); // Load style default over global style

// Icons functionality
const(char)* GuiIconText (int iconId, const(char)* text); // Get text with icon id prepended (if supported)

void GuiDrawIcon (int iconId, int posX, int posY, int pixelSize, Color color);

uint* GuiGetIcons (); // Get full icons data pointer
uint* GuiGetIconData (int iconId); // Get icon bit data
void GuiSetIconData (int iconId, uint* data); // Set icon bit data
void GuiSetIconScale (uint scale); // Set icon scale (1 by default)

void GuiSetIconPixel (int iconId, int x, int y); // Set icon pixel value
void GuiClearIconPixel (int iconId, int x, int y); // Clear icon pixel value
bool GuiCheckIconPixel (int iconId, int x, int y); // Check icon pixel value

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
    ICON_206 = 206,
    ICON_207 = 207,
    ICON_208 = 208,
    ICON_209 = 209,
    ICON_210 = 210,
    ICON_211 = 211,
    ICON_212 = 212,
    ICON_213 = 213,
    ICON_214 = 214,
    ICON_215 = 215,
    ICON_216 = 216,
    ICON_217 = 217,
    ICON_218 = 218,
    ICON_219 = 219,
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

// Prevents name mangling of functions

// RAYGUI_H

/***********************************************************************************
*
*   RAYGUI IMPLEMENTATION
*
************************************************************************************/

// Required for: FILE, fopen(), fclose(), fprintf(), feof(), fscanf(), vsprintf() [GuiLoadStyle(), GuiLoadIcons()]
// Required for: malloc(), calloc(), free() [GuiLoadStyle(), GuiLoadIcons()]
// Required for: strlen() [GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()], memset(), memcpy()
// Required for: va_list, va_start(), vfprintf(), va_end() [TextFormat()]
// Required for: roundf() [GuiColorPicker()]

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
// ICON_206
// ICON_207
// ICON_208
// ICON_209
// ICON_210
// ICON_211
// ICON_212
// ICON_213
// ICON_214
// ICON_215
// ICON_216
// ICON_217
// ICON_218
// ICON_219
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

// !RAYGUI_NO_ICONS && !RAYGUI_CUSTOM_ICONS

// Maximum number of standard controls
// Maximum number of standard properties
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
// Gui element transpacency on drawing

// Gui icon default scale (if icons enabled)

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

// -- GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()
//-------------------------------------------------------------------------------

// Drawing required functions
//-------------------------------------------------------------------------------
// -- GuiDrawRectangle(), GuiDrawIcon()

// -- GuiColorPicker()
//-------------------------------------------------------------------------------

// Text required functions
//-------------------------------------------------------------------------------
// -- GuiLoadStyle()
// -- GuiLoadStyleDefault()
// -- GuiLoadStyle()
// -- GuiLoadStyle()
// -- GuiLoadStyle()
// -- GuiLoadStyle()

// -- GetTextWidth(), GuiTextBoxMulti()
// -- GuiDrawText()
//-------------------------------------------------------------------------------

// raylib functions already implemented in raygui
//-------------------------------------------------------------------------------
// Returns a Color struct from hexadecimal value
// Returns hexadecimal value for a Color
// Color fade-in or fade-out, alpha goes from 0.0f to 1.0f
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
// Gui get text width using default font
// Get text bounds considering control bounds
// Get text icon if provided and move text cursor

// Gui draw text using default font
// Gui draw rectangle using default raygui style

// Split controls text into multiple strings
// Convert color data from HSV to RGB
// Convert color data from RGB to HSV

// Scroll bar control, used by GuiScrollPanel()

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

// Scroll Panel control

// Text will be drawn as a header bar (if provided)

// Move panel bounds after the header bar

// Recheck to account for the other scrollbar being visible

// Calculate view area (area without the scrollbars)

// Clip view area to the actual content size

// Update control
//--------------------------------------------------------------------

// Check button state

// Horizontal scroll (Shift + Mouse wheel)

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
// ...
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

// Toggle Group control, returns toggled button index

// Get substrings items from text (items pointers)

// Check Box control, returns true when active

// Update control
//--------------------------------------------------------------------

// Check checkbox state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Combo Box control, returns selected item index

// Get substrings items from text (items pointers, lengths and count)

// Update control
//--------------------------------------------------------------------

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

// Check mouse button pressed

// Update control
//--------------------------------------------------------------------

// Check if mouse has been pressed or released outside limits

// Check if already selected item has been pressed again

// Check focused and selected item

// Update item rectangle y position for next item

// Item selected, change to editMode = false

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw visible items

// Update item rectangle y position for next item

// Draw arrows (using icon if available)

// ICON_ARROW_DOWN_FILL

//--------------------------------------------------------------------

// Text Box control, updates input text
// NOTE 2: Returns if KEY_ENTER pressed (useful for data validation)

// Update control
//--------------------------------------------------------------------

// Returns codepoint as Unicode

// Only allow keys in range [32..125]

// Delete text

// Check text alignment to position cursor properly

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// in case we edit and text does not fit in the textbox show right aligned and character clipped, slower but working

// Draw cursor

//--------------------------------------------------------------------

// Spinner control, returns selected value

// Update control
//--------------------------------------------------------------------

// Check spinner state

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------
// TODO: Set Spinner properties for ValueBox

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

// WARNING: BLANK color does not work properly with Fade()

// Draw cursor

// NOTE: ValueBox internal text is always centered

// Draw text label if provided

//--------------------------------------------------------------------

// Text Box control with multiple lines

// Cursor position, [x, y] values should be updated

// Character rectangle scaling factor

// Update control
//--------------------------------------------------------------------

// We get an Unicode codepoint

// Length in bytes (UTF-8 string)

// Introduce characters

// Supports Unicode inputs -> Encoded to UTF-8

// Delete characters

// Remove ASCII equivalent character (1 byte)

// Remove latest UTF-8 unicode character introduced (n bytes)

// Exit edit mode

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// 0-No wrap, 1-Char wrap, 2-Word wrap

//int lastSpacePos = 0;
//int lastSpaceWidth = 0;
//int lastSpaceCursorPos = 0;

// If requested codepoint is not found, we get '?' (0x3f)

// Glyph measures

// Line feed
// Carriage return

// Jump line if the end of the text box area has been reached

// Line feed
// Carriage return

/*
if ((codepointLength == 1) && (codepoint == ' '))
{
    lastSpacePos = i;
    lastSpaceWidth = 0;
    lastSpaceCursorPos = cursorPos.x;
}

// Jump line if last word reaches end of text box area
if ((lastSpaceCursorPos + lastSpaceWidth) > (textAreaBounds.x + textAreaBounds.width))
{
    cursorPos.y += 12;               // Line feed
    cursorPos.x = textAreaBounds.x;  // Carriage return
}
*/

// Draw current character glyph

//if (i > lastSpacePos) lastSpaceWidth += (atlasRec.width + (float)GuiGetStyle(DEFAULT, TEXT_SPACING));

// Draw cursor position considering text glyphs

//--------------------------------------------------------------------

// Slider control with pro parameters
// NOTE: Other GuiSlider*() controls use this one

// Slider

// SliderBar

// Update control
//--------------------------------------------------------------------

// Get equivalent value and slider position from mousePoint.x

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

// Update control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

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

// Grid control
// NOTE: Returns grid mouse-hover selected cell
// About drawing lines at subpixel spacing, simple put, not easy solution:
// https://stackoverflow.com/questions/4435450/2d-opengl-drawing-lines-that-dont-exactly-fit-pixel-raster

// Grid lines alpha amount

// Update control
//--------------------------------------------------------------------

// NOTE: Cell values must be rounded to int

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// TODO: Draw background panel?

// Draw vertical grid lines

// Draw horizontal grid lines

//----------------------------------------------------------------------------------
// Styles loading functions
//----------------------------------------------------------------------------------

// Load raygui style file (.rgs)
// NOTE: By default a binary file is expected, that file could contain a custom font,
// in that case, custom font image atlas is GRAY+ALPHA and pixel data can be compressed (DEFLATE)

// Try reading the files as text file first

// Style property: p <control_id> <property_id> <property_value> <property_name>

// Style font: f <gen_font_size> <charmap_file> <font_file>

// Load characters from charmap file,
// expected '\n' separated list of integer values

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

// Load font recs data

// Load font chars info data

// Set font texture source rectangle to be used as white texture to draw shapes
// NOTE: This way, all gui can be draw using a single draw call

// Load style default over global style

// We set this variable first to avoid cyclic function calls
// when calling GuiSetStyle() and GuiGetStyle()

// Initialize default LIGHT style property values

// WARNING: Some controls use other values
// WARNING: Some controls use other values
// WARNING: Some controls use other values

// Initialize control-specific property values
// NOTE: Those properties are in default list but require specific values by control type

// Initialize extended property values
// NOTE: By default, extended property values are initialized to 0
// DEFAULT, shared by all controls
// DEFAULT, shared by all controls
// DEFAULT specific property
// DEFAULT specific property

// Initialize default font

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

// Read icons data directly over guiIcons data array

// Draw selected icon using rectangles pixel-by-pixel

// Get icon bit data
// NOTE: Bit data array grouped as unsigned int (RAYGUI_ICON_SIZE*RAYGUI_ICON_SIZE/32 elements)

// Set icon bit data
// NOTE: Data must be provided as unsigned int array (RAYGUI_ICON_SIZE*RAYGUI_ICON_SIZE/32 elements)

// Set icon scale (1 by default)

// Set icon pixel value

// This logic works for any RAYGUI_ICON_SIZE pixels icons,
// For example, in case of 16x16 pixels, every 2 lines fit in one unsigned int data element

// Clear icon pixel value

// This logic works for any RAYGUI_ICON_SIZE pixels icons,
// For example, in case of 16x16 pixels, every 2 lines fit in one unsigned int data element

// Check icon pixel value

// !RAYGUI_NO_ICONS

//----------------------------------------------------------------------------------
// Module specific Functions Definition
//----------------------------------------------------------------------------------
// Gui get text width considering icon

// Make sure guiFont is set, GuiGetStyle() initializes it lazynessly

// Get text bounds considering control bounds

// Consider TEXT_PADDING properly, depends on control type and TEXT_ALIGNMENT

// NOTE: ValueBox text value always centered, text padding applies to label

// TODO: Special cases (no label): COMBOBOX, DROPDOWNBOX, LISTVIEW (scrollbar?)
// More special cases (label on side): CHECKBOX, SLIDER, VALUEBOX, SPINNER

// Get text icon if provided and move text cursor
// NOTE: We support up to 999 values for iconId

// Maybe we have an icon!

// Maximum length for icon value: 3 digits + '\0'

// Move text pointer after icon
// WARNING: If only icon provided, it could point to EOL character: '\0'

// Gui draw text using default font

// Vertical alignment for pixel perfect

// Check text for icon and move cursor

// Get text position depending on alignment and iconId
//---------------------------------------------------------------------------------

// NOTE: We get text size after icon has been processed
// TODO: REVIEW: We consider text size in case of line breaks! -> MeasureTextEx() depends on raylib!

//int textWidth = GetTextWidth(text);
//int textHeight = GuiGetStyle(DEFAULT, TEXT_SIZE);

// If text requires an icon, add size to measure

// WARNING: If only icon provided, text could be pointing to EOF character: '\0'

// Check guiTextAlign global variables

// NOTE: Make sure we get pixel-perfect coordinates,
// In case of decimals we got weird text positioning

//---------------------------------------------------------------------------------

// Draw text (with icon if available)
//---------------------------------------------------------------------------------

// NOTE: We consider icon height, probably different than text size

//---------------------------------------------------------------------------------

// Gui draw rectangle using default raygui plain style with borders

// Draw rectangle filled with color

// Draw rectangle border lines with color

// Split controls text into multiple strings
// Also check for multiple columns (required by GuiToggleGroup())

// NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
// inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
// all used memory is static... it has some limitations:
//      1. Maximum number of possible split strings is set by RAYGUI_TEXTSPLIT_MAX_ITEMS
//      2. Maximum size of text to split is RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE
// NOTE: Those definitions could be externally provided if required

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

// Make sure the slider won't get outside of the scrollbar

// Update control
//--------------------------------------------------------------------

// Handle mouse wheel

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

// Returns a Color struct from hexadecimal value

// Returns hexadecimal value for a Color

// Check if point is inside rectangle

// Color fade-in or fade-out, alpha goes from 0.0f to 1.0f

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

/*
    UTF-8 specs from https://www.ietf.org/rfc/rfc3629.txt

    Char. number range  |        UTF-8 octet sequence
      (hexadecimal)    |              (binary)
    --------------------+---------------------------------------------
    0000 0000-0000 007F | 0xxxxxxx
    0000 0080-0000 07FF | 110xxxxx 10xxxxxx
    0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
    0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
*/
// NOTE: on decode errors we return as soon as possible

// Codepoint (defaults to '?')
// The first UTF8 octet

// Only one octet (ASCII range x00-7F)

// Two octets

// [0]xC2-DF    [1]UTF8-tail(x80-BF)

// Unexpected sequence

// Three octets

// Unexpected sequence

// Unexpected sequence

// [0]xE0    [1]xA0-BF       [2]UTF8-tail(x80-BF)
// [0]xE1-EC [1]UTF8-tail    [2]UTF8-tail(x80-BF)
// [0]xED    [1]x80-9F       [2]UTF8-tail(x80-BF)
// [0]xEE-EF [1]UTF8-tail    [2]UTF8-tail(x80-BF)

// Four octets

// Unexpected sequence

// Unexpected sequence

// Unexpected sequence

// [0]xF0       [1]x90-BF       [2]UTF8-tail  [3]UTF8-tail
// [0]xF1-F3    [1]UTF8-tail    [2]UTF8-tail  [3]UTF8-tail
// [0]xF4       [1]x80-8F       [2]UTF8-tail  [3]UTF8-tail

// Unexpected sequence

// Codepoints after U+10ffff are invalid

// RAYGUI_STANDALONE

// RAYGUI_IMPLEMENTATION
