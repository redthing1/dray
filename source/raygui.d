module raygui;

/*******************************************************************************************
*
*   raygui v2.8 - A simple and easy-to-use immediate-mode gui library
*
*   DESCRIPTION:
*
*   raygui is a tools-dev-focused immediate-mode-gui library based on raylib but also
*   available as a standalone library, as long as input and drawing functions are provided.
*
*   Controls provided:
*
*   # Container/separators Controls
*       - WindowBox
*       - GroupBox
*       - Line
*       - Panel
*
*   # Basic Controls
*       - Label
*       - Button
*       - LabelButton   --> Label
*       - ImageButton   --> Button
*       - ImageButtonEx --> Button
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
*       - ScrollBar
*       - ScrollPanel
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
*   CONFIGURATION:
*
*   #define RAYGUI_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers
*       or source files without problems. But only ONE file should hold the implementation.
*
*   #define RAYGUI_STATIC (defined by default)
*       The generated implementation will stay private inside implementation file and all
*       internal symbols and functions will only be visible inside that file.
*
*   #define RAYGUI_STANDALONE
*       Avoid raylib.h header inclusion in this file. Data types defined on raylib are defined
*       internally in the library and input management and drawing functions must be provided by
*       the user (check library implementation for further details).
*
*   #define RAYGUI_SUPPORT_ICONS
*       Includes riconsdata.h header defining a set of 128 icons (binary format) to be used on
*       multiple controls and following raygui styles
*
*
*   VERSIONS HISTORY:
*       2.8 (03-May-2020) Centralized rectangles drawing to GuiDrawRectangle()
*       2.7 (20-Feb-2020) Added possible tooltips API
*       2.6 (09-Sep-2019) ADDED: GuiTextInputBox()
*                         REDESIGNED: GuiListView*(), GuiDropdownBox(), GuiSlider*(), GuiProgressBar(), GuiMessageBox()
*                         REVIEWED: GuiTextBox(), GuiSpinner(), GuiValueBox(), GuiLoadStyle()
*                         Replaced property INNER_PADDING by TEXT_PADDING, renamed some properties
*                         Added 8 new custom styles ready to use
*                         Multiple minor tweaks and bugs corrected
*       2.5 (28-May-2019) Implemented extended GuiTextBox(), GuiValueBox(), GuiSpinner()
*       2.3 (29-Apr-2019) Added rIcons auxiliar library and support for it, multiple controls reviewed
*                         Refactor all controls drawing mechanism to use control state
*       2.2 (05-Feb-2019) Added GuiScrollBar(), GuiScrollPanel(), reviewed GuiListView(), removed Gui*Ex() controls
*       2.1 (26-Dec-2018) Redesign of GuiCheckBox(), GuiComboBox(), GuiDropdownBox(), GuiToggleGroup() > Use combined text string
*                         Complete redesign of style system (breaking change)
*       2.0 (08-Nov-2018) Support controls guiLock and custom fonts, reviewed GuiComboBox(), GuiListView()...
*       1.9 (09-Oct-2018) Controls review: GuiGrid(), GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()...
*       1.8 (01-May-2018) Lot of rework and redesign to align with rGuiStyler and rGuiLayout
*       1.5 (21-Jun-2017) Working in an improved styles system
*       1.4 (15-Jun-2017) Rewritten all GUI functions (removed useless ones)
*       1.3 (12-Jun-2017) Redesigned styles system
*       1.1 (01-Jun-2017) Complete review of the library
*       1.0 (07-Jun-2016) Converted to header-only by Ramon Santamaria.
*       0.9 (07-Mar-2016) Reviewed and tested by Albert Martos, Ian Eito, Sergio Martinez and Ramon Santamaria.
*       0.8 (27-Aug-2015) Initial release. Implemented by Kevin Gato, Daniel Nicolás and Ramon Santamaria.
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, redesign, update and maintenance...
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
*   Copyright (c) 2014-2020 Ramon Santamaria (@raysan5)
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

enum RAYGUI_VERSION = "3.0";

// Function specifiers in case library is build/used as a shared library (Windows)
// NOTE: Microsoft specifiers to tell compiler that symbols are imported/exported from a .dll

// We are building the library as a Win32 shared library (.dll)

// We are using the library as a Win32 shared library (.dll)

// Function specifiers definition // Functions defined as 'extern' by default (implicit specifiers)

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------

// TODO: Implement custom TraceLog()

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
    int propertyValue;
}

// Gui control state
enum GuiControlState
{
    GUI_STATE_NORMAL = 0,
    GUI_STATE_FOCUSED = 1,
    GUI_STATE_PRESSED = 2,
    GUI_STATE_DISABLED = 3
}

// Gui control text alignment
enum GuiTextAlignment
{
    GUI_TEXT_ALIGN_LEFT = 0,
    GUI_TEXT_ALIGN_CENTER = 1,
    GUI_TEXT_ALIGN_RIGHT = 2
}

// Gui controls
enum GuiControl
{
    DEFAULT = 0, // Generic control -> populates to all controls when set
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
    SPINNER = 11,
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

// DEFAULT extended properties
// NOTE: Those properties are actually common to all controls
enum GuiDefaultProperty
{
    TEXT_SIZE = 16,
    TEXT_SPACING = 17,
    LINE_COLOR = 18,
    BACKGROUND_COLOR = 19
}

// Label
//typedef enum { } GuiLabelProperty;

// Button
//typedef enum { } GuiButtonProperty;

// Toggle/ToggleGroup
enum GuiToggleProperty
{
    GROUP_PADDING = 16
}

// Slider/SliderBar
enum GuiSliderProperty
{
    SLIDER_WIDTH = 16,
    SLIDER_PADDING = 17
}

// ProgressBar
enum GuiProgressBarProperty
{
    PROGRESS_PADDING = 16
}

// CheckBox
enum GuiCheckBoxProperty
{
    CHECK_PADDING = 16
}

// ComboBox
enum GuiComboBoxProperty
{
    COMBO_BUTTON_WIDTH = 16,
    COMBO_BUTTON_PADDING = 17
}

// DropdownBox
enum GuiDropdownBoxProperty
{
    ARROW_PADDING = 16,
    DROPDOWN_ITEMS_PADDING = 17
}

// TextBox/TextBoxMulti/ValueBox/Spinner
enum GuiTextBoxProperty
{
    TEXT_INNER_PADDING = 16,
    TEXT_LINES_PADDING = 17,
    COLOR_SELECTED_FG = 18,
    COLOR_SELECTED_BG = 19
}

// Spinner
enum GuiSpinnerProperty
{
    SPIN_BUTTON_WIDTH = 16,
    SPIN_BUTTON_PADDING = 17
}

// ScrollBar
enum GuiScrollBarProperty
{
    ARROWS_SIZE = 16,
    ARROWS_VISIBLE = 17,
    SCROLL_SLIDER_PADDING = 18,
    SCROLL_SLIDER_SIZE = 19,
    SCROLL_PADDING = 20,
    SCROLL_SPEED = 21
}

// ScrollBar side
enum GuiScrollBarSide
{
    SCROLLBAR_LEFT_SIDE = 0,
    SCROLLBAR_RIGHT_SIDE = 1
}

// ListView
enum GuiListViewProperty
{
    LIST_ITEMS_HEIGHT = 16,
    LIST_ITEMS_PADDING = 17,
    SCROLLBAR_WIDTH = 18,
    SCROLLBAR_SIDE = 19
}

// ColorPicker
enum GuiColorPickerProperty
{
    COLOR_SELECTOR_SIZE = 16,
    HUEBAR_WIDTH = 17, // Right hue bar width
    HUEBAR_PADDING = 18, // Right hue bar separation from panel
    HUEBAR_SELECTOR_HEIGHT = 19, // Right hue bar selector height
    HUEBAR_SELECTOR_OVERFLOW = 20 // Right hue bar selector overflow
}

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
void GuiPanel (Rectangle bounds); // Panel control, useful to group controls
Rectangle GuiScrollPanel (Rectangle bounds, Rectangle content, Vector2* scroll); // Scroll Panel control

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
int GuiScrollBar (Rectangle bounds, int value, int minValue, int maxValue); // Scroll Bar control
Vector2 GuiGrid (Rectangle bounds, float spacing, int subdivs); // Grid control

// Advance controls set
int GuiListView (Rectangle bounds, const(char)* text, int* scrollIndex, int active); // List View control, returns selected list item index
int GuiListViewEx (Rectangle bounds, const(char*)* text, int count, int* focus, int* scrollIndex, int active); // List View with extended parameters
int GuiMessageBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons); // Message Box control, displays a message
int GuiTextInputBox (Rectangle bounds, const(char)* title, const(char)* message, const(char)* buttons, char* text); // Text Input Box control, ask for text
Color GuiColorPicker (Rectangle bounds, Color color); // Color Picker control (multiple color controls)
Color GuiColorPanel (Rectangle bounds, Color color); // Color Panel control
float GuiColorBarAlpha (Rectangle bounds, float alpha); // Color Bar Alpha control
float GuiColorBarHue (Rectangle bounds, float value); // Color Bar Hue control

// Styles loading functions
void GuiLoadStyle (const(char)* fileName); // Load style file over global style variable (.rgs)
void GuiLoadStyleDefault (); // Load style default over global style

/*
typedef GuiStyle (unsigned int *)
RAYGUIAPI GuiStyle LoadGuiStyle(const char *fileName);          // Load style from file (.rgs)
RAYGUIAPI void UnloadGuiStyle(GuiStyle style);                  // Unload style
*/

const(char)* GuiIconText (int iconId, const(char)* text); // Get text with icon id prepended (if supported)

// Gui icons functionality
void GuiDrawIcon (int iconId, int posX, int posY, int pixelSize, Color color);

uint* GuiGetIcons (); // Get full icons data pointer
uint* GuiGetIconData (int iconId); // Get icon bit data
void GuiSetIconData (int iconId, uint* data); // Set icon bit data

void GuiSetIconPixel (int iconId, int x, int y); // Set icon pixel value
void GuiClearIconPixel (int iconId, int x, int y); // Clear icon pixel value
bool GuiCheckIconPixel (int iconId, int x, int y); // Check icon pixel value

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

// External icons data provided, it can be generated with rGuiIcons tool

// Embedded raygui icons, no external file provided

// Size of icons (squared)
// Maximum number of icons
// Maximum length of icon name id

// Icons data is defined by bit array (every bit represents one pixel)
// Those arrays are stored as unsigned int data arrays, so every array
// element defines 32 pixels (bits) of information
// Number of elemens depend on RICON_SIZE (by default 16x16 pixels)

//----------------------------------------------------------------------------------
// Icons enumeration
//----------------------------------------------------------------------------------

enum GuiIconName {
    RICON_NONE                     = 0,
    RICON_FOLDER_FILE_OPEN         = 1,
    RICON_FILE_SAVE_CLASSIC        = 2,
    RICON_FOLDER_OPEN              = 3,
    RICON_FOLDER_SAVE              = 4,
    RICON_FILE_OPEN                = 5,
    RICON_FILE_SAVE                = 6,
    RICON_FILE_EXPORT              = 7,
    RICON_FILE_NEW                 = 8,
    RICON_FILE_DELETE              = 9,
    RICON_FILETYPE_TEXT            = 10,
    RICON_FILETYPE_AUDIO           = 11,
    RICON_FILETYPE_IMAGE           = 12,
    RICON_FILETYPE_PLAY            = 13,
    RICON_FILETYPE_VIDEO           = 14,
    RICON_FILETYPE_INFO            = 15,
    RICON_FILE_COPY                = 16,
    RICON_FILE_CUT                 = 17,
    RICON_FILE_PASTE               = 18,
    RICON_CURSOR_HAND              = 19,
    RICON_CURSOR_POINTER           = 20,
    RICON_CURSOR_CLASSIC           = 21,
    RICON_PENCIL                   = 22,
    RICON_PENCIL_BIG               = 23,
    RICON_BRUSH_CLASSIC            = 24,
    RICON_BRUSH_PAINTER            = 25,
    RICON_WATER_DROP               = 26,
    RICON_COLOR_PICKER             = 27,
    RICON_RUBBER                   = 28,
    RICON_COLOR_BUCKET             = 29,
    RICON_TEXT_T                   = 30,
    RICON_TEXT_A                   = 31,
    RICON_SCALE                    = 32,
    RICON_RESIZE                   = 33,
    RICON_FILTER_POINT             = 34,
    RICON_FILTER_BILINEAR          = 35,
    RICON_CROP                     = 36,
    RICON_CROP_ALPHA               = 37,
    RICON_SQUARE_TOGGLE            = 38,
    RICON_SYMMETRY                 = 39,
    RICON_SYMMETRY_HORIZONTAL      = 40,
    RICON_SYMMETRY_VERTICAL        = 41,
    RICON_LENS                     = 42,
    RICON_LENS_BIG                 = 43,
    RICON_EYE_ON                   = 44,
    RICON_EYE_OFF                  = 45,
    RICON_FILTER_TOP               = 46,
    RICON_FILTER                   = 47,
    RICON_TARGET_POINT             = 48,
    RICON_TARGET_SMALL             = 49,
    RICON_TARGET_BIG               = 50,
    RICON_TARGET_MOVE              = 51,
    RICON_CURSOR_MOVE              = 52,
    RICON_CURSOR_SCALE             = 53,
    RICON_CURSOR_SCALE_RIGHT       = 54,
    RICON_CURSOR_SCALE_LEFT        = 55,
    RICON_UNDO                     = 56,
    RICON_REDO                     = 57,
    RICON_REREDO                   = 58,
    RICON_MUTATE                   = 59,
    RICON_ROTATE                   = 60,
    RICON_REPEAT                   = 61,
    RICON_SHUFFLE                  = 62,
    RICON_EMPTYBOX                 = 63,
    RICON_TARGET                   = 64,
    RICON_TARGET_SMALL_FILL        = 65,
    RICON_TARGET_BIG_FILL          = 66,
    RICON_TARGET_MOVE_FILL         = 67,
    RICON_CURSOR_MOVE_FILL         = 68,
    RICON_CURSOR_SCALE_FILL        = 69,
    RICON_CURSOR_SCALE_RIGHT_FILL  = 70,
    RICON_CURSOR_SCALE_LEFT_FILL   = 71,
    RICON_UNDO_FILL                = 72,
    RICON_REDO_FILL                = 73,
    RICON_REREDO_FILL              = 74,
    RICON_MUTATE_FILL              = 75,
    RICON_ROTATE_FILL              = 76,
    RICON_REPEAT_FILL              = 77,
    RICON_SHUFFLE_FILL             = 78,
    RICON_EMPTYBOX_SMALL           = 79,
    RICON_BOX                      = 80,
    RICON_BOX_TOP                  = 81,
    RICON_BOX_TOP_RIGHT            = 82,
    RICON_BOX_RIGHT                = 83,
    RICON_BOX_BOTTOM_RIGHT         = 84,
    RICON_BOX_BOTTOM               = 85,
    RICON_BOX_BOTTOM_LEFT          = 86,
    RICON_BOX_LEFT                 = 87,
    RICON_BOX_TOP_LEFT             = 88,
    RICON_BOX_CENTER               = 89,
    RICON_BOX_CIRCLE_MASK          = 90,
    RICON_POT                      = 91,
    RICON_ALPHA_MULTIPLY           = 92,
    RICON_ALPHA_CLEAR              = 93,
    RICON_DITHERING                = 94,
    RICON_MIPMAPS                  = 95,
    RICON_BOX_GRID                 = 96,
    RICON_GRID                     = 97,
    RICON_BOX_CORNERS_SMALL        = 98,
    RICON_BOX_CORNERS_BIG          = 99,
    RICON_FOUR_BOXES               = 100,
    RICON_GRID_FILL                = 101,
    RICON_BOX_MULTISIZE            = 102,
    RICON_ZOOM_SMALL               = 103,
    RICON_ZOOM_MEDIUM              = 104,
    RICON_ZOOM_BIG                 = 105,
    RICON_ZOOM_ALL                 = 106,
    RICON_ZOOM_CENTER              = 107,
    RICON_BOX_DOTS_SMALL           = 108,
    RICON_BOX_DOTS_BIG             = 109,
    RICON_BOX_CONCENTRIC           = 110,
    RICON_BOX_GRID_BIG             = 111,
    RICON_OK_TICK                  = 112,
    RICON_CROSS                    = 113,
    RICON_ARROW_LEFT               = 114,
    RICON_ARROW_RIGHT              = 115,
    RICON_ARROW_DOWN               = 116,
    RICON_ARROW_UP                 = 117,
    RICON_ARROW_LEFT_FILL          = 118,
    RICON_ARROW_RIGHT_FILL         = 119,
    RICON_ARROW_DOWN_FILL          = 120,
    RICON_ARROW_UP_FILL            = 121,
    RICON_AUDIO                    = 122,
    RICON_FX                       = 123,
    RICON_WAVE                     = 124,
    RICON_WAVE_SINUS               = 125,
    RICON_WAVE_SQUARE              = 126,
    RICON_WAVE_TRIANGULAR          = 127,
    RICON_CROSS_SMALL              = 128,
    RICON_PLAYER_PREVIOUS          = 129,
    RICON_PLAYER_PLAY_BACK         = 130,
    RICON_PLAYER_PLAY              = 131,
    RICON_PLAYER_PAUSE             = 132,
    RICON_PLAYER_STOP              = 133,
    RICON_PLAYER_NEXT              = 134,
    RICON_PLAYER_RECORD            = 135,
    RICON_MAGNET                   = 136,
    RICON_LOCK_CLOSE               = 137,
    RICON_LOCK_OPEN                = 138,
    RICON_CLOCK                    = 139,
    RICON_TOOLS                    = 140,
    RICON_GEAR                     = 141,
    RICON_GEAR_BIG                 = 142,
    RICON_BIN                      = 143,
    RICON_HAND_POINTER             = 144,
    RICON_LASER                    = 145,
    RICON_COIN                     = 146,
    RICON_EXPLOSION                = 147,
    RICON_1UP                      = 148,
    RICON_PLAYER                   = 149,
    RICON_PLAYER_JUMP              = 150,
    RICON_KEY                      = 151,
    RICON_DEMON                    = 152,
    RICON_TEXT_POPUP               = 153,
    RICON_GEAR_EX                  = 154,
    RICON_CRACK                    = 155,
    RICON_CRACK_POINTS             = 156,
    RICON_STAR                     = 157,
    RICON_DOOR                     = 158,
    RICON_EXIT                     = 159,
    RICON_MODE_2D                  = 160,
    RICON_MODE_3D                  = 161,
    RICON_CUBE                     = 162,
    RICON_CUBE_FACE_TOP            = 163,
    RICON_CUBE_FACE_LEFT           = 164,
    RICON_CUBE_FACE_FRONT          = 165,
    RICON_CUBE_FACE_BOTTOM         = 166,
    RICON_CUBE_FACE_RIGHT          = 167,
    RICON_CUBE_FACE_BACK           = 168,
    RICON_CAMERA                   = 169,
    RICON_SPECIAL                  = 170,
    RICON_LINK_NET                 = 171,
    RICON_LINK_BOXES               = 172,
    RICON_LINK_MULTI               = 173,
    RICON_LINK                     = 174,
    RICON_LINK_BROKE               = 175,
    RICON_TEXT_NOTES               = 176,
    RICON_NOTEBOOK                 = 177,
    RICON_SUITCASE                 = 178,
    RICON_SUITCASE_ZIP             = 179,
    RICON_MAILBOX                  = 180,
    RICON_MONITOR                  = 181,
    RICON_PRINTER                  = 182,
    RICON_PHOTO_CAMERA             = 183,
    RICON_PHOTO_CAMERA_FLASH       = 184,
    RICON_HOUSE                    = 185,
    RICON_HEART                    = 186,
    RICON_CORNER                   = 187,
    RICON_VERTICAL_BARS            = 188,
    RICON_VERTICAL_BARS_FILL       = 189,
    RICON_LIFE_BARS                = 190,
    RICON_INFO                     = 191,
    RICON_CROSSLINE                = 192,
    RICON_HELP                     = 193,
    RICON_FILETYPE_ALPHA           = 194,
    RICON_FILETYPE_HOME            = 195,
    RICON_LAYERS_VISIBLE           = 196,
    RICON_LAYERS                   = 197,
    RICON_WINDOW                   = 198,
    RICON_HIDPI                    = 199,
    RICON_200                      = 200,
    RICON_201                      = 201,
    RICON_202                      = 202,
    RICON_203                      = 203,
    RICON_204                      = 204,
    RICON_205                      = 205,
    RICON_206                      = 206,
    RICON_207                      = 207,
    RICON_208                      = 208,
    RICON_209                      = 209,
    RICON_210                      = 210,
    RICON_211                      = 211,
    RICON_212                      = 212,
    RICON_213                      = 213,
    RICON_214                      = 214,
    RICON_215                      = 215,
    RICON_216                      = 216,
    RICON_217                      = 217,
    RICON_218                      = 218,
    RICON_219                      = 219,
    RICON_220                      = 220,
    RICON_221                      = 221,
    RICON_222                      = 222,
    RICON_223                      = 223,
    RICON_224                      = 224,
    RICON_225                      = 225,
    RICON_226                      = 226,
    RICON_227                      = 227,
    RICON_228                      = 228,
    RICON_229                      = 229,
    RICON_230                      = 230,
    RICON_231                      = 231,
    RICON_232                      = 232,
    RICON_233                      = 233,
    RICON_234                      = 234,
    RICON_235                      = 235,
    RICON_236                      = 236,
    RICON_237                      = 237,
    RICON_238                      = 238,
    RICON_239                      = 239,
    RICON_240                      = 240,
    RICON_241                      = 241,
    RICON_242                      = 242,
    RICON_243                      = 243,
    RICON_244                      = 244,
    RICON_245                      = 245,
    RICON_246                      = 246,
    RICON_247                      = 247,
    RICON_248                      = 248,
    RICON_249                      = 249,
    RICON_250                      = 250,
    RICON_251                      = 251,
    RICON_252                      = 252,
    RICON_253                      = 253,
    RICON_254                      = 254,
    RICON_255                      = 255,
}

//----------------------------------------------------------------------------------
// Icons data for all gui possible icons (allocated on data segment by default)
//
// NOTE 1: Every icon is codified in binary form, using 1 bit per pixel, so,
// every 16x16 icon requires 8 integers (16*16/32) to be stored
//
// NOTE 2: A new icon set could be loaded over this array using GuiLoadIcons(),
// but loaded icons set must be same RICON_SIZE and no more than RICON_MAX_ICONS
//
// guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
//----------------------------------------------------------------------------------

// RICON_NONE
// RICON_FOLDER_FILE_OPEN
// RICON_FILE_SAVE_CLASSIC
// RICON_FOLDER_OPEN
// RICON_FOLDER_SAVE
// RICON_FILE_OPEN
// RICON_FILE_SAVE
// RICON_FILE_EXPORT
// RICON_FILE_NEW
// RICON_FILE_DELETE
// RICON_FILETYPE_TEXT
// RICON_FILETYPE_AUDIO
// RICON_FILETYPE_IMAGE
// RICON_FILETYPE_PLAY
// RICON_FILETYPE_VIDEO
// RICON_FILETYPE_INFO
// RICON_FILE_COPY
// RICON_FILE_CUT
// RICON_FILE_PASTE
// RICON_CURSOR_HAND
// RICON_CURSOR_POINTER
// RICON_CURSOR_CLASSIC
// RICON_PENCIL
// RICON_PENCIL_BIG
// RICON_BRUSH_CLASSIC
// RICON_BRUSH_PAINTER
// RICON_WATER_DROP
// RICON_COLOR_PICKER
// RICON_RUBBER
// RICON_COLOR_BUCKET
// RICON_TEXT_T
// RICON_TEXT_A
// RICON_SCALE
// RICON_RESIZE
// RICON_FILTER_POINT
// RICON_FILTER_BILINEAR
// RICON_CROP
// RICON_CROP_ALPHA
// RICON_SQUARE_TOGGLE
// RICON_SIMMETRY
// RICON_SIMMETRY_HORIZONTAL
// RICON_SIMMETRY_VERTICAL
// RICON_LENS
// RICON_LENS_BIG
// RICON_EYE_ON
// RICON_EYE_OFF
// RICON_FILTER_TOP
// RICON_FILTER
// RICON_TARGET_POINT
// RICON_TARGET_SMALL
// RICON_TARGET_BIG
// RICON_TARGET_MOVE
// RICON_CURSOR_MOVE
// RICON_CURSOR_SCALE
// RICON_CURSOR_SCALE_RIGHT
// RICON_CURSOR_SCALE_LEFT
// RICON_UNDO
// RICON_REDO
// RICON_REREDO
// RICON_MUTATE
// RICON_ROTATE
// RICON_REPEAT
// RICON_SHUFFLE
// RICON_EMPTYBOX
// RICON_TARGET
// RICON_TARGET_SMALL_FILL
// RICON_TARGET_BIG_FILL
// RICON_TARGET_MOVE_FILL
// RICON_CURSOR_MOVE_FILL
// RICON_CURSOR_SCALE_FILL
// RICON_CURSOR_SCALE_RIGHT
// RICON_CURSOR_SCALE_LEFT
// RICON_UNDO_FILL
// RICON_REDO_FILL
// RICON_REREDO_FILL
// RICON_MUTATE_FILL
// RICON_ROTATE_FILL
// RICON_REPEAT_FILL
// RICON_SHUFFLE_FILL
// RICON_EMPTYBOX_SMALL
// RICON_BOX
// RICON_BOX_TOP
// RICON_BOX_TOP_RIGHT
// RICON_BOX_RIGHT
// RICON_BOX_BOTTOM_RIGHT
// RICON_BOX_BOTTOM
// RICON_BOX_BOTTOM_LEFT
// RICON_BOX_LEFT
// RICON_BOX_TOP_LEFT
// RICON_BOX_CIRCLE_MASK
// RICON_BOX_CENTER
// RICON_POT
// RICON_ALPHA_MULTIPLY
// RICON_ALPHA_CLEAR
// RICON_DITHERING
// RICON_MIPMAPS
// RICON_BOX_GRID
// RICON_GRID
// RICON_BOX_CORNERS_SMALL
// RICON_BOX_CORNERS_BIG
// RICON_FOUR_BOXES
// RICON_GRID_FILL
// RICON_BOX_MULTISIZE
// RICON_ZOOM_SMALL
// RICON_ZOOM_MEDIUM
// RICON_ZOOM_BIG
// RICON_ZOOM_ALL
// RICON_ZOOM_CENTER
// RICON_BOX_DOTS_SMALL
// RICON_BOX_DOTS_BIG
// RICON_BOX_CONCENTRIC
// RICON_BOX_GRID_BIG
// RICON_OK_TICK
// RICON_CROSS
// RICON_ARROW_LEFT
// RICON_ARROW_RIGHT
// RICON_ARROW_DOWN
// RICON_ARROW_UP
// RICON_ARROW_LEFT_FILL
// RICON_ARROW_RIGHT_FILL
// RICON_ARROW_DOWN_FILL
// RICON_ARROW_UP_FILL
// RICON_AUDIO
// RICON_FX
// RICON_WAVE
// RICON_WAVE_SINUS
// RICON_WAVE_SQUARE
// RICON_WAVE_TRIANGULAR
// RICON_CROSS_SMALL
// RICON_PLAYER_PREVIOUS
// RICON_PLAYER_PLAY_BACK
// RICON_PLAYER_PLAY
// RICON_PLAYER_PAUSE
// RICON_PLAYER_STOP
// RICON_PLAYER_NEXT
// RICON_PLAYER_RECORD
// RICON_MAGNET
// RICON_LOCK_CLOSE
// RICON_LOCK_OPEN
// RICON_CLOCK
// RICON_TOOLS
// RICON_GEAR
// RICON_GEAR_BIG
// RICON_BIN
// RICON_HAND_POINTER
// RICON_LASER
// RICON_COIN
// RICON_EXPLOSION
// RICON_1UP
// RICON_PLAYER
// RICON_PLAYER_JUMP
// RICON_KEY
// RICON_DEMON
// RICON_TEXT_POPUP
// RICON_GEAR_EX
// RICON_CRACK
// RICON_CRACK_POINTS
// RICON_STAR
// RICON_DOOR
// RICON_EXIT
// RICON_MODE_2D
// RICON_MODE_3D
// RICON_CUBE
// RICON_CUBE_FACE_TOP
// RICON_CUBE_FACE_LEFT
// RICON_CUBE_FACE_FRONT
// RICON_CUBE_FACE_BOTTOM
// RICON_CUBE_FACE_RIGHT
// RICON_CUBE_FACE_BACK
// RICON_CAMERA
// RICON_SPECIAL
// RICON_LINK_NET
// RICON_LINK_BOXES
// RICON_LINK_MULTI
// RICON_LINK
// RICON_LINK_BROKE
// RICON_TEXT_NOTES
// RICON_NOTEBOOK
// RICON_SUITCASE
// RICON_SUITCASE_ZIP
// RICON_MAILBOX
// RICON_MONITOR
// RICON_PRINTER
// RICON_PHOTO_CAMERA
// RICON_PHOTO_CAMERA_FLASH
// RICON_HOUSE
// RICON_HEART
// RICON_CORNER
// RICON_VERTICAL_BARS
// RICON_VERTICAL_BARS_FILL
// RICON_LIFE_BARS
// RICON_INFO
// RICON_CROSSLINE
// RICON_HELP
// RICON_FILETYPE_ALPHA
// RICON_FILETYPE_HOME
// RICON_LAYERS_VISIBLE
// RICON_LAYERS
// RICON_WINDOW
// RICON_HIDPI
// RICON_200
// RICON_201
// RICON_202
// RICON_203
// RICON_204
// RICON_205
// RICON_206
// RICON_207
// RICON_208
// RICON_209
// RICON_210
// RICON_211
// RICON_212
// RICON_213
// RICON_214
// RICON_215
// RICON_216
// RICON_217
// RICON_218
// RICON_219
// RICON_220
// RICON_221
// RICON_222
// RICON_223
// RICON_224
// RICON_225
// RICON_226
// RICON_227
// RICON_228
// RICON_229
// RICON_230
// RICON_231
// RICON_232
// RICON_233
// RICON_234
// RICON_235
// RICON_236
// RICON_237
// RICON_238
// RICON_239
// RICON_240
// RICON_241
// RICON_242
// RICON_243
// RICON_244
// RICON_245
// RICON_246
// RICON_247
// RICON_248
// RICON_249
// RICON_250
// RICON_251
// RICON_252
// RICON_253
// RICON_254
// RICON_255

// RAYGUI_CUSTOM_RICONS

// !RAYGUI_NO_RICONS

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

// Gui current font (WARNING: highly coupled to raylib)
// Gui lock state (no inputs processed)
// Gui element transpacency on drawing

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

//----------------------------------------------------------------------------------
// Gui Setup Functions Definition
//----------------------------------------------------------------------------------
// Enable gui global state

// Disable gui global state

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

// NOTE: This define is also used by GuiMessageBox() and GuiTextInputBox()

//GuiControlState state = guiState;

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

// Draw control
//--------------------------------------------------------------------

//--------------------------------------------------------------------

// Scroll Panel control

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

// RICON_ARROW_DOWN_FILL

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

// Scroll Bar control

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

// RICON_ARROW_UP_FILL / RICON_ARROW_LEFT_FILL

// RICON_ARROW_DOWN_FILL / RICON_ARROW_RIGHT_FILL

//--------------------------------------------------------------------

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

//--------------------------------------------------------------------

// Draw control
//--------------------------------------------------------------------

// Draw vertical grid lines

// Draw horizontal grid lines

//----------------------------------------------------------------------------------
// Styles loading functions
//----------------------------------------------------------------------------------

// Load raygui style file (.rgs)

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
// they are returned as a guiIconsName[iconCount][RICON_MAX_NAME_LENGTH],
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
// NOTE: Bit data array grouped as unsigned int (ICON_SIZE*ICON_SIZE/32 elements)

// Set icon bit data
// NOTE: Data must be provided as unsigned int array (ICON_SIZE*ICON_SIZE/32 elements)

// Set icon pixel value

// This logic works for any RICON_SIZE pixels icons,
// For example, in case of 16x16 pixels, every 2 lines fit in one unsigned int data element

// Clear icon pixel value

// This logic works for any RICON_SIZE pixels icons,
// For example, in case of 16x16 pixels, every 2 lines fit in one unsigned int data element

// Check icon pixel value

// !RAYGUI_NO_RICONS

//----------------------------------------------------------------------------------
// Module specific Functions Definition
//----------------------------------------------------------------------------------
// Gui get text width using default font
// NOTE: Icon is not considered here

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
//      1. Maximum number of possible split strings is set by TEXTSPLIT_MAX_TEXT_ELEMENTS
//      2. Maximum size of text to split is TEXTSPLIT_MAX_TEXT_LENGTH
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

// Returns a Color struct from hexadecimal value

// Returns hexadecimal value for a Color

// Check if point is inside rectangle

// Color fade-in or fade-out, alpha goes from 0.0f to 1.0f

// Formatting of text with variables to 'embed'

// Draw rectangle with vertical gradient fill color
// NOTE: This function is only used by GuiColorPicker()

// Size of static buffer: TextSplit()
// Size of static pointers array: TextSplit()

// Split string into multiple strings

// NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
// inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
// all used memory is static... it has some limitations:
//      1. Maximum number of possible split strings is set by TEXTSPLIT_MAX_SUBSTRINGS_COUNT
//      2. Maximum size of text to split is TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH

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
