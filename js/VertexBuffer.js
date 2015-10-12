"use strict";

function VertexBuffer(itemSize, itemType, data)
{
	this.itemSize = itemSize;
	this.itemCount = data.length / itemSize;
	this.itemType = itemType
	
	this.vbo = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, this.vbo);
	gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
}

VertexBuffer.prototype.bind = function(attributeIndex)
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.vbo)
	gl.enableVertexAttribArray(attributeIndex)
	gl.vertexAttribPointer(attributeIndex, this.itemSize, this.itemType, false, 0, 0)
}
