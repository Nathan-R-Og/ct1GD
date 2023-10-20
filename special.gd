extends Node



func trueLength(vecx, vecy):
	var parseAngle = (atan2(vecy, vecx))
	return Vector2(cos(parseAngle),sin(parseAngle))

