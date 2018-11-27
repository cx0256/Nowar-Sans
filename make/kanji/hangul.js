"use strict";

function isHangulSyllables(c) {
	return c >= 0xac00 && c < 0xd7b0;
}

function isHangulJamo(c) {
	return c >= 0x1100 && c < 0x1200;
}

function isHangulCompatJamo(c) {
	return c >= 0x3130 && c < 0x3190;
}

function isHangulJamoExtA(c) {
	return c >= 0xa960 && c < 0xa980;
}

function isHangulJamoExtB(c) {
	return c >= 0xd7b0 && c < 0xD800;
}

exports.isHangul = function isHangul(c) {
	return isHangulSyllables(c) ||
	isHangulJamo(c) ||
	isHangulCompatJamo(c) ||
	isHangulJamoExtA(c) ||
	isHangulJamoExtB(c);
}
