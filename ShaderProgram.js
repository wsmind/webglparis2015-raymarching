"use strict";

function ShaderProgram(vertexCode, fragmentCode)
{
    this.errors = []
    
	var vertexShader = this._compileShader(gl.VERTEX_SHADER, vertexCode)
	var fragmentShader = this._compileShader(gl.FRAGMENT_SHADER, fragmentCode)
	
	this.program = gl.createProgram()
	gl.attachShader(this.program, vertexShader)
	gl.attachShader(this.program, fragmentShader)
	gl.linkProgram(this.program)
    
    gl.deleteShader(vertexShader)
    gl.deleteShader(fragmentShader)
	
	if (!gl.getProgramParameter(this.program, gl.LINK_STATUS))
    {
		this.errors.push("Link failed")
    }
}

ShaderProgram.prototype.destroy = function()
{
	gl.deleteProgram(this.program)
}

ShaderProgram.prototype.bind = function()
{
	gl.useProgram(this.program)
}

ShaderProgram.prototype.getAttributeLocation = function(name)
{
	return gl.getAttribLocation(this.program, name);
}

ShaderProgram.prototype.bindAttribLocation = function(index, name)
{
	return gl.bindAttribLocation(this.program, index, name);
}

ShaderProgram.prototype.setFloatUniform = function(name, value)
{
	var location = gl.getUniformLocation(this.program, name)
	gl.uniform1f(location, value)
}

ShaderProgram.prototype.setVec2Uniform = function(name, value)
{
	var location = gl.getUniformLocation(this.program, name)
	gl.uniform2f(location, value[0], value[1])
}

ShaderProgram.prototype.setVec3Uniform = function(name, value)
{
	var location = gl.getUniformLocation(this.program, name)
	gl.uniform3f(location, value[0], value[1], value[2])
}

ShaderProgram.prototype.setMat4Uniform = function(name, value)
{
	var location = gl.getUniformLocation(this.program, name)
	gl.uniformMatrix4fv(location, false, value);
}

ShaderProgram.prototype._compileShader = function(type, code)
{
	var shader = gl.createShader(type)
	
	gl.shaderSource(shader, code)
	gl.compileShader(shader)
	
	if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
	{
		this.errors.push(gl.getShaderInfoLog(shader))
		return null
	}
	
	return shader
}
