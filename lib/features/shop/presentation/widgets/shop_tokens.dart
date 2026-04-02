import 'package:flutter/material.dart';

const Color shopBg = Color(0xFF040A1A);
const Color shopPanel = Color(0xFF08142D);
const Color shopBorder = Color(0x6616D5FF);
const Color shopBlue = Color(0xFF16D5FF);
const Color shopBlueDeep = Color(0xFF0F55FF);
const Color shopPurple = Color(0xFF8B5CF6);
const Color shopGreen = Color(0xFF22C55E);
const Color shopAmber = Color(0xFFFDE047);
const Color shopMuted = Color(0xFF6B7280);
const Color shopWhite = Color(0xFFE5EEFF);

const LinearGradient shopPrimaryGradient = LinearGradient(
  colors: <Color>[shopBlue, shopBlueDeep],
);

const LinearGradient shopRemoveAdsGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0x4D16D5FF), shopBg],
);
