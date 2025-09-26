const String ttNormsFont = 'TTNorms';
const String libreBaskerVilleFont = 'LibreBaskerville';
const String kollektif = 'Kollektif';

enum ToastieFontFamily {
  ttNorms,
  libreBaskerville,
  kollektif,
}

Map<ToastieFontFamily, String> toastieFontFamilyMap = {
  ToastieFontFamily.ttNorms: ttNormsFont,
  ToastieFontFamily.libreBaskerville: libreBaskerVilleFont,
  ToastieFontFamily.kollektif: kollektif,
};
