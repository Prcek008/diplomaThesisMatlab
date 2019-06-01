peaqAdvancedSubCell = {};
peaqBasicSubCell = {};
pemoqSubCell = {};
visqolSubCell = {};


load('odg_mp2_stereo_peaq.mat');
peaqBasicSubCell(1) = {odg};
load('odg_lc_stereo_peaq.mat');
peaqBasicSubCell(2) = {odg};
load('odg_he_stereo_peaq.mat');
peaqBasicSubCell(3) = {odg};
load('odg_hev2_stereo_peaq.mat');
peaqBasicSubCell(4) = {odg};
load('odg_opus_stereo_peaq.mat');
peaqBasicSubCell(5) = {odg};
load('odg_xhe_stereo_peaq.mat');
peaqBasicSubCell(6) = {odg};
load('odg_anchor_stereo_peaq.mat');
peaqBasicSubCell(7) = {odg};

load('odg_mp2_stereo_peaqAdvanced.mat');
peaqAdvancedSubCell(1) = {odg};
load('odg_lc_stereo_peaqAdvanced.mat');
peaqAdvancedSubCell(2) = {odg};
load('odg_he_stereo_peaqAdvanced.mat');
peaqAdvancedSubCell(3) = {odg};
load('odg_hev2_stereo_peaqAdvanced.mat');
peaqAdvancedSubCell(4) = {odg};
load('odg_opus_stereo_peaqAdvanced.mat');
peaqAdvancedSubCell(5) = {odg};
load('odg_xhe_stereo_peaqAdvanced.mat');
peaqBasicSubCell(6) = {odg};
load('odg_anchor_stereo_peaqAdvanced.mat');
peaqBasicSubCell(7) = {odg};


load('odg_mp2_stereo_pemoq.mat');
pemoqSubCell(1) = {odg};
load('odg_lc_stereo_pemoq.mat');
pemoqSubCell(2) = {odg};
load('odg_he_stereo_pemoq.mat');
pemoqSubCell(3) = {odg};
load('odg_hev2_stereo_pemoq.mat');
pemoqSubCell(4) = {odg};
load('odg_opus_stereo_pemoq.mat');
pemoqSubCell(5) = {odg};
load('odg_xhe_stereo_pemoq.mat');
peaqBasicSubCell(6) = {odg};
load('odg_anchor_stereo_pemoq.mat');
peaqBasicSubCell(7) = {odg};

load('odg_mp2_stereo_visqol.mat');
visqolSubCell(1) = {odg};
load('odg_lc_stereo_visqol.mat');
visqolSubCell(2) = {odg};
load('odg_he_stereo_visqol.mat');
visqolSubCell(3) = {odg};
load('odg_hev2_stereo_visqol.mat');
visqolSubCell(4) = {odg};
load('odg_opus_stereo_visqol.mat');
visqolSubCell(5) = {odg};
load('odg_xhe_stereo_visqol.mat');
peaqBasicSubCell(6) = {odg};
load('odg_anchor_stereo_visqol.mat');
peaqBasicSubCell(7) = {odg};

objectiveResults = {peaqAdvancedSubCell,peaqBasicSubCell,pemoqSubCell,visqolSubCell};
save('objectiveResults.mat','objectiveResults');