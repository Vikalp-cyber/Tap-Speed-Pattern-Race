import 'package:flutter/material.dart';

const Color gameplayBg = Color(0xFF040A1A);
const Color gameplayPanel = Color(0xFF08142D);
const Color gameplayPanelElevated = Color(0xFF0C1938);
const Color gameplayBorder = Color(0x6616D5FF);
const Color gameplaySoftBorder = Color(0x3316D5FF);
const Color gameplayBlue = Color(0xFF16D5FF);
const Color gameplayBlueDeep = Color(0xFF0F55FF);
const Color gameplayPurple = Color(0xFF8B5CF6);
const Color gameplayGreen = Color(0xFF22C55E);
const Color gameplayRed = Color(0xFFEF4444);
const Color gameplayAmber = Color(0xFFFDE047);
const Color gameplayMuted = Color(0xFF8CA3C7);
const Color gameplayDim = Color(0xFF5F7092);
const Color gameplayWhite = Color(0xFFE5EEFF);

const LinearGradient gameplayPrimaryGradient = LinearGradient(
  colors: <Color>[gameplayBlue, gameplayBlueDeep],
);

const LinearGradient gameplayVictoryGradient = LinearGradient(
  colors: <Color>[gameplayAmber, gameplayWhite, gameplayBlue],
);

const LinearGradient gameplayPanelGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[gameplayPanelElevated, gameplayPanel],
);
