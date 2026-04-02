import 'package:flutter/material.dart';

const Color profileBg = Color(0xFF040A1A);
const Color profilePanel = Color(0xFF08142D);
const Color profilePanelElevated = Color(0xFF0B1835);
const Color profileBorder = Color(0x6616D5FF);
const Color profileBlue = Color(0xFF16D5FF);
const Color profileBlueDeep = Color(0xFF0F55FF);
const Color profilePurple = Color(0xFF8B5CF6);
const Color profileGreen = Color(0xFF22C55E);
const Color profileRed = Color(0xFFEF4444);
const Color profileAmber = Color(0xFFFDE047);
const Color profileMuted = Color(0xFF8CA3C7);
const Color profileDim = Color(0xFF5F7092);
const Color profileWhite = Color(0xFFE5EEFF);

const LinearGradient profileAvatarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[profileBlue, profilePurple],
);

const LinearGradient profilePanelGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[profilePanelElevated, profilePanel],
);

const LinearGradient profileHeroGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0xCC0B1835), Color(0xCC08142D)],
);
