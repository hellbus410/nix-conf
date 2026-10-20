# Office documents: OnlyOffice, and the fonts they ask for.
{ pkgs, ... }:
{
  home-manager.users.demiurge.home.packages = with pkgs; [
    onlyoffice-desktopeditors
  ];

  # fonts .docx/.xlsx/.pptx files ask for, so layouts match Word
  fonts.packages = with pkgs; [
    corefonts # Arial, Times New Roman, Courier New, Verdana, Georgia, Trebuchet MS, Impact 
    vista-fonts # Calibri, Cambria, Candara, Consolas, Constantia, Corbel
    paratype-pt-sans # PT Sans/Serif/Mono
    paratype-pt-serif
    paratype-pt-mono
    noto-fonts 
    roboto 
    open-sans
    lato
    liberation_ttf
  ];
}
