module rlgl;

import raylib;

extern (C) @nogc nothrow:

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------
// Default internal render batch limits

// This is the maximum amount of elements (quads) per batch
// NOTE: Be careful with text, every letter maps to a quad
enum DEFAULT_BATCH_BUFFER_ELEMENTS = 8192;

// We reduce memory sizes for embedded systems (RPI and HTML5)
// NOTE: On HTML5 (emscripten) this is allocated on heap,
// by default it's only 16MB!...just take care...

enum DEFAULT_BATCH_BUFFERS = 1; // Default number of batch buffers (multi-buffering)

enum DEFAULT_BATCH_DRAWCALLS = 256; // Default number of batch draw calls (by state changes: mode, texture)

enum MAX_BATCH_ACTIVE_TEXTURES = 4; // Maximum number of additional textures that can be activated on batch drawing (SetShaderValueTexture())

// Internal Matrix stack

enum MAX_MATRIX_STACK_SIZE = 32; // Maximum size of Matrix stack

// Shader and material limits

enum MAX_SHADER_LOCATIONS = 32; // Maximum number of shader locations supported

enum MAX_MATERIAL_MAPS = 12; // Maximum number of shader maps supported

// Projection matrix culling

enum RL_CULL_DISTANCE_NEAR = 0.01; // Default near cull distance

enum RL_CULL_DISTANCE_FAR = 1000.0; // Default far cull distance

// Texture parameters (equivalent to OpenGL defines)
enum RL_TEXTURE_WRAP_S = 0x2802; // GL_TEXTURE_WRAP_S
enum RL_TEXTURE_WRAP_T = 0x2803; // GL_TEXTURE_WRAP_T
enum RL_TEXTURE_MAG_FILTER = 0x2800; // GL_TEXTURE_MAG_FILTER
enum RL_TEXTURE_MIN_FILTER = 0x2801; // GL_TEXTURE_MIN_FILTER
enum RL_TEXTURE_ANISOTROPIC_FILTER = 0x3000; // Anisotropic filter (custom identifier)

enum RL_FILTER_NEAREST = 0x2600; // GL_NEAREST
enum RL_FILTER_LINEAR = 0x2601; // GL_LINEAR
enum RL_FILTER_MIP_NEAREST = 0x2700; // GL_NEAREST_MIPMAP_NEAREST
enum RL_FILTER_NEAREST_MIP_LINEAR = 0x2702; // GL_NEAREST_MIPMAP_LINEAR
enum RL_FILTER_LINEAR_MIP_NEAREST = 0x2701; // GL_LINEAR_MIPMAP_NEAREST
enum RL_FILTER_MIP_LINEAR = 0x2703; // GL_LINEAR_MIPMAP_LINEAR

enum RL_WRAP_REPEAT = 0x2901; // GL_REPEAT
enum RL_WRAP_CLAMP = 0x812F; // GL_CLAMP_TO_EDGE
enum RL_WRAP_MIRROR_REPEAT = 0x8370; // GL_MIRRORED_REPEAT
enum RL_WRAP_MIRROR_CLAMP = 0x8742; // GL_MIRROR_CLAMP_EXT

// Matrix modes (equivalent to OpenGL)
enum RL_MODELVIEW = 0x1700; // GL_MODELVIEW
enum RL_PROJECTION = 0x1701; // GL_PROJECTION
enum RL_TEXTURE = 0x1702; // GL_TEXTURE

// Primitive assembly draw modes
enum RL_LINES = 0x0001; // GL_LINES
enum RL_TRIANGLES = 0x0004; // GL_TRIANGLES
enum RL_QUADS = 0x0007; // GL_QUADS

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
enum GlVersion
{
    OPENGL_11 = 1,
    OPENGL_21 = 2,
    OPENGL_33 = 3,
    OPENGL_ES_20 = 4
}

enum FramebufferAttachType
{
    RL_ATTACHMENT_COLOR_CHANNEL0 = 0,
    RL_ATTACHMENT_COLOR_CHANNEL1 = 1,
    RL_ATTACHMENT_COLOR_CHANNEL2 = 2,
    RL_ATTACHMENT_COLOR_CHANNEL3 = 3,
    RL_ATTACHMENT_COLOR_CHANNEL4 = 4,
    RL_ATTACHMENT_COLOR_CHANNEL5 = 5,
    RL_ATTACHMENT_COLOR_CHANNEL6 = 6,
    RL_ATTACHMENT_COLOR_CHANNEL7 = 7,
    RL_ATTACHMENT_DEPTH = 100,
    RL_ATTACHMENT_STENCIL = 200
}

enum FramebufferTexType
{
    RL_ATTACHMENT_CUBEMAP_POSITIVE_X = 0,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_X = 1,
    RL_ATTACHMENT_CUBEMAP_POSITIVE_Y = 2,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y = 3,
    RL_ATTACHMENT_CUBEMAP_POSITIVE_Z = 4,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z = 5,
    RL_ATTACHMENT_TEXTURE2D = 100,
    RL_ATTACHMENT_RENDERBUFFER = 200
}

// Prevents name mangling of functions

//------------------------------------------------------------------------------------
// Functions Declaration - Matrix operations
//------------------------------------------------------------------------------------
void rlMatrixMode (int mode); // Choose the current matrix to be transformed
void rlPushMatrix (); // Push the current matrix to stack
void rlPopMatrix (); // Pop lattest inserted matrix from stack
void rlLoadIdentity (); // Reset current matrix to identity matrix
void rlTranslatef (float x, float y, float z); // Multiply the current matrix by a translation matrix
void rlRotatef (float angleDeg, float x, float y, float z); // Multiply the current matrix by a rotation matrix
void rlScalef (float x, float y, float z); // Multiply the current matrix by a scaling matrix
void rlMultMatrixf (float* matf); // Multiply the current matrix by another matrix
void rlFrustum (double left, double right, double bottom, double top, double znear, double zfar);
void rlOrtho (double left, double right, double bottom, double top, double znear, double zfar);
void rlViewport (int x, int y, int width, int height); // Set the viewport area

//------------------------------------------------------------------------------------
// Functions Declaration - Vertex level operations
//------------------------------------------------------------------------------------
void rlBegin (int mode); // Initialize drawing mode (how to organize vertex)
void rlEnd (); // Finish vertex providing
void rlVertex2i (int x, int y); // Define one vertex (position) - 2 int
void rlVertex2f (float x, float y); // Define one vertex (position) - 2 float
void rlVertex3f (float x, float y, float z); // Define one vertex (position) - 3 float
void rlTexCoord2f (float x, float y); // Define one vertex (texture coordinate) - 2 float
void rlNormal3f (float x, float y, float z); // Define one vertex (normal) - 3 float
void rlColor4ub (ubyte r, ubyte g, ubyte b, ubyte a); // Define one vertex (color) - 4 byte
void rlColor3f (float x, float y, float z); // Define one vertex (color) - 3 float
void rlColor4f (float x, float y, float z, float w); // Define one vertex (color) - 4 float

//------------------------------------------------------------------------------------
// Functions Declaration - OpenGL equivalent functions (common to 1.1, 3.3+, ES2)
// NOTE: This functions are used to completely abstract raylib code from OpenGL layer
//------------------------------------------------------------------------------------
void rlEnableTexture (uint id); // Enable texture usage
void rlDisableTexture (); // Disable texture usage
void rlTextureParameters (uint id, int param, int value); // Set texture parameters (filter, wrap)
void rlEnableShader (uint id); // Enable shader program usage
void rlDisableShader (); // Disable shader program usage
void rlEnableFramebuffer (uint id); // Enable render texture (fbo)
void rlDisableFramebuffer (); // Disable render texture (fbo), return to default framebuffer
void rlEnableDepthTest (); // Enable depth test
void rlDisableDepthTest (); // Disable depth test
void rlEnableDepthMask (); // Enable depth write
void rlDisableDepthMask (); // Disable depth write
void rlEnableBackfaceCulling (); // Enable backface culling
void rlDisableBackfaceCulling (); // Disable backface culling
void rlEnableScissorTest (); // Enable scissor test
void rlDisableScissorTest (); // Disable scissor test
void rlScissor (int x, int y, int width, int height); // Scissor test
void rlEnableWireMode (); // Enable wire mode
void rlDisableWireMode (); // Disable wire mode
void rlSetLineWidth (float width); // Set the line drawing width
float rlGetLineWidth (); // Get the line drawing width
void rlEnableSmoothLines (); // Enable line aliasing
void rlDisableSmoothLines (); // Disable line aliasing

void rlClearColor (ubyte r, ubyte g, ubyte b, ubyte a); // Clear color buffer with color
void rlClearScreenBuffers (); // Clear used screen buffers (color and depth)
void rlUpdateBuffer (int bufferId, void* data, int dataSize); // Update GPU buffer with new data
uint rlLoadAttribBuffer (uint vaoId, int shaderLoc, void* buffer, int size, bool dynamic); // Load a new attributes buffer

//------------------------------------------------------------------------------------
// Functions Declaration - rlgl functionality
//------------------------------------------------------------------------------------
void rlglInit (int width, int height); // Initialize rlgl (buffers, shaders, textures, states)
void rlglClose (); // De-inititialize rlgl (buffers, shaders, textures)
void rlglDraw (); // Update and draw default internal buffers
void rlCheckErrors (); // Check and log OpenGL error codes

int rlGetVersion (); // Returns current OpenGL version
bool rlCheckBufferLimit (int vCount); // Check internal buffer overflow for a given number of vertex
void rlSetDebugMarker (const(char)* text); // Set debug marker for analysis
void rlSetBlendMode (int glSrcFactor, int glDstFactor, int glEquation); // // Set blending mode factor and equation (using OpenGL factors)
void rlLoadExtensions (void* loader); // Load OpenGL extensions

// Textures data management
uint rlLoadTexture (void* data, int width, int height, int format, int mipmapCount); // Load texture in GPU
uint rlLoadTextureDepth (int width, int height, bool useRenderBuffer); // Load depth texture/renderbuffer (to be attached to fbo)
uint rlLoadTextureCubemap (void* data, int size, int format); // Load texture cubemap
void rlUpdateTexture (uint id, int offsetX, int offsetY, int width, int height, int format, const(void)* data); // Update GPU texture with new data
void rlGetGlTextureFormats (int format, uint* glInternalFormat, uint* glFormat, uint* glType); // Get OpenGL internal formats
void rlUnloadTexture (uint id); // Unload texture from GPU memory

void rlGenerateMipmaps (Texture2D* texture); // Generate mipmap data for selected texture
void* rlReadTexturePixels (Texture2D texture); // Read texture pixel data
ubyte* rlReadScreenPixels (int width, int height); // Read screen pixel data (color buffer)

// Framebuffer management (fbo)
uint rlLoadFramebuffer (int width, int height); // Load an empty framebuffer
void rlFramebufferAttach (uint fboId, uint texId, int attachType, int texType); // Attach texture/renderbuffer to a framebuffer
bool rlFramebufferComplete (uint id); // Verify framebuffer is complete
void rlUnloadFramebuffer (uint id); // Delete framebuffer from GPU

// Vertex data management
void rlLoadMesh (Mesh* mesh, bool dynamic); // Upload vertex data into GPU and provided VAO/VBO ids
void rlUpdateMesh (Mesh mesh, int buffer, int count); // Update vertex or index data on GPU (upload new data to one buffer)
void rlUpdateMeshAt (Mesh mesh, int buffer, int count, int index); // Update vertex or index data on GPU, at index
void rlDrawMesh (Mesh mesh, Material material, Matrix transform); // Draw a 3d mesh with material and transform
void rlDrawMeshInstanced (Mesh mesh, Material material, Matrix* transforms, int count); // Draw a 3d mesh with material and transform
void rlUnloadMesh (Mesh mesh); // Unload mesh data from CPU and GPU
