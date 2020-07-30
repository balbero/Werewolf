if not WereWolf.IsCorrectVersion() then return end

if not(GetLocale() == "frFR") then
  return
end

local L = WereWolf.L


-- Tooltip translation
L["|cffeda55fLeft-Click|r to toggle showing the main window."] = "|cffeda55fClic-Gauche|r pour afficher/cacher la fenêtre principale"
L["|cffeda55fMiddle-Click|r to toggle the minimap icon on or off."] = "|cffeda55fClic-Milieu|r pour afficher/cacher l'icone de la minimap"

-- MainFrame translation
L["Options will finish loading after combat ends."] = "Les options s'afficheront après le combat"
L["Show this message"] = "Affiche ce message"
L["Toggle the minimap icon"] = "Affiche/Cache l'icone de la minimap"
L["Toggle the config frame"] = "Affiche/Cache le panneau des options"
L["Usage:"] = "Utilisation:"
L["Use /wa minimap to show the minimap icon again"] = "Utilisez |cff0000ff/ww minimap|r pour afficher un nouvelle fois l'icone de minimap"
L["Start"] = "Demarrer"
L["Game Rules"] = "Règles du jeu"
L["Game Setup"] = "Configuration de la partie"
L["GamePanel"] = "Panneau de jeu"
L["Invite"] = "Inviter"
L["GMOptions"] = "Options de Maitre de Jeu"
L["AddonGameMaster"] = "L'addon est le Maitre du Jeu"
L["PlayGameMaster"] = "Vous êtes le Maitre de Jeu"
L["TimerOptions"] = "Duréer des phases"
L["VotePhaseTimer"] = "Durée de la phase de vote (sec)"
L["WerewolfPhaseTimer"] = "Durée de la phase Loupo-garrou (sec)"
L["There is not enough player into the group to start a game!"] = "Il n'y a pas assez de joueur pour démarrer une partie!"
L["Ok"] = "Ok"

-- Rogue panel
L["You choose : "] = "Vous avez choisi : "
L["Choose Wisely"] = "Choisissez sagement"

-- invite popup
L["%s invited you tu play Werewolf.  Are you ok?"] = "%s t'invite à jouer au Loup-garrou. T'es partant?"
L["Play it"] = "C'est parti"
L["Hell No"] = "Non merci"

-- Info tab
L["GameGoalHeader"] = "BUT DU JEU"
L["GameDescription"] = "Pour les Villageois: éliminer les Loups-Garous\nPour les Loups-Garous: éliminer les Villageois"
L["GameCharacter"] = "PERSONNAGES"
L["GameCharPeon"] = "Chaque nuit, l'un d'entre eux est dévoré par les Loups-Garous. Ce joueur est éliminé du jeu. Les Villageois survivant se réunissent le lendemain matin et essaient de remarquer , chez les autres joueurs, les signes qui trahiraient leur identité nocturne de mangeur d'homme. Après discussion, ils votent l'éxécution d'un suspect qui sera éliminé du jeu."
L["GameCharWereWolf"] = "Chaque nuit, ils dévorent un Villageois. Le jour ils essaient de masquer leur identité nocturne pour échapper à la vindicte populaire. Ils sont 1, 2, 3 ou 4 suivant le nombre de joueurs et les variantes appliquées."
L["SpecialGameCharacter"] = "Personnages Spéciaux"
L["GameCharSeer"] = "Chaque nuit, elle découvre la vraie personnalité d'un joueur de son choix. Elle doit aider les autres villageois, mais rester discrète pour ne pas être démasquée par les Loups-garous."
L["GameCharHunter"] = "S'il se fait dévorer par les Loups Garous ou exécuter malencontreusement par les joueurs, le Chasseur a le pouvoir de répliquer avant de rendre l'âme, en éliminant immédiatement n'importe quel autre joueur de son choix."
L["GameCharCupid"] = "En décochant ses célèbres flèches magique, Cupidon a le pouvoir de rendre 2 personnes amoureuses à jamais. La première nuit (tour préliminaire), il désigne les 2 joueurs (ou joueuses ou 1 joueur et 1 joueuse) amoureux. Cupidon peut, s'il le veut, se désigner comme l'un des Amoureux."
L["GameCharWitch"] = "Elle sait concocter 2 potions extrèmement puissantes: Une potion de guérison, pour ressusciter le joueur tué par les Loups-Garous, une potion d'empoisonnement, utilisée la nuit pour éliminer un joueur. La sorcière ne peut utiliser chaque potion qu'une seule fois dans la partie. Elle peut se servir de ses 2 potions dans la même nuit. Le matin suivant il pourra, suivant l'usage de ce pouvoir, y avoir 0 mort, 1 mort ou 2 morts. La sorcière peut utiliser les potions à son profit, et donc se guérir elle-même. Si au bout d'un certain nombre de parties, vous trouvez ce personnage trop puissant, limitez ses pouvoirs à une seule potion pour la partie."
L["GameCharCathy"] = "La Petite Fille peut, en entrouvrant les yeux, espionner les Loups Garous pendant leur réveil. Si elle se fait surprendre par un des Loups-Garous, elle meurt immédiatement (en silence), à la place de la victime désignée. Le Petite Fille ne peut espionner que la nuit, durant le tour d'éveil des Loups-Garous."
L["GameCharCaptain"] = "Cette carte est confiée à un des joueurs, en plus de se carte de personnage. Le Capitaine est élu par vote, à la majorité relative. On ne peut refuser l'honneur d'être capitaine. Dorénavant, les votes de ce joueur comptent pour 2 voix. Si ce joueur se fait éliminer, dans son dernier souffle il désigne son successeur."
L["GameCharRogue"] = "Si on veut jouer le Voleur, il faut ajouter deux cartes Simples Villageois en plus de toutes celles déja choisies. Après disttribution, les deux cartes non distribuées sont placées au centre de la table face cachée. La première nuit, le voleur pourra prendre connaissance de ses deux cartes, et échanger sa carte contre l'une des deux autres. Si ces deux cartes sont des Loups Garous, il est obligé d'échanger sa carte contre un des deux Loups Garous. Il jouera désormais ce personnage jusqu'à la fin de la partie."
L["GameCharLover"] = "Si l'un des amoureux est éliminé, l'autre meurt de chagrin immédiatement. Un Amoureux ne doit jamais voter contre son aimé (même pour faire semblant !) Attention: Si l'un des deux Amoureux est un Loup-Garou et l'autre un Villageois, le but de la partie change pour eux. Pour vivre en paix leur amour et gagner la partie, ils doivent éliminer tous les autres joueurs , Loups-Garous et Villageois, en respectant les règles du jeu."

-- Char tab
L["Kill"] = "Tuer!"
L["Werewolves"] = "Les Loups-Garou"
L["Peons"] = "Les Villageois"
L["win"] = "remportent la victoire!"

-- Timer frame translation
L["Time Left"] = "Temp restant"
L["Game starting"] = "La partie démarre"

-- Options translation
L["Werewolf"] = "Loup garou"
L["Just kill"] = "Tuer, juste tuer"
L["Kill every peon"] = "Tuer tous les péons"
L["Peon"] = "Villageois"
L["Just survive"] = "Survivre!" 
L["Survive to werewolf attacks"] = "Survivre aux attaques des Loups garou" 
L["Hunter"] = "Chasseur"
L["Can point a player to come with him into death"] = "Peut désigner un joueur pour l'accompagner dans la mort"
L["Cathy"] = "Cathy"
L["Can spy the werewolf during night. Beware! do not be catch or you will be immediatly dead!"] = "Peut espionner les loup garou pendant la nuit. MAis attention à ne pas se faire voir, sinon c'est la mort qui vous accueil"
L["Spy and survive to werewolf attacks"] = "Espioner et survivre aux attaques des Loups garou"
L["Witch"] = "Sorcière"
L["Can concoct poisonous or healing potion"] = "Peut concocter une potion de soin ou d'empoisonnement"
L["Captain"] = "Capitaine"
L["Vote count double. On death,  point another player to become the new captain."] = "Votre vote compte double. A votre mort, vous devez désigner votre successeur"
L["Cupid"] = "Cupidon"
L["Point two players to become the lovers"] = "Designe deux joueurs qui deviennent amant. (peut se désigner lui-même comme un amant)"
L["Rogue"] = "Voleur"
L["During the first night,  can choose its new role among two roles"] = "Durant la première nuit, vous pouvez choisir votre role parmis deux proposés"
L["Seer"] = "Voyante"
L["Each night, can discover the true nature of players"] = "Chaque nuit, peut découvrir la vrai nature d'un joueur"
L["Lover"] = "Amant"
L["Cannot survive if the other one dies."] = "Ne peut survivre si l'autre meurt"
L["Game Master"] = "Maitre du jeu"
L["You are the game master"] = "Vous êtes le maitre du jeu"
L["Manage the game!"] = "Gerer le jeu!"


-- state translation
L["The night fall on the village and everyone fells asleep"] = "La nuit tombe sur le village et tout le monde s'endort..."
L["The day rises again with its shinny sun and its grim discovery..."] = "Le jour se lève à nouveau de son soleil éclatant et de sa macabre découverte..."
L["Villagers vote! Point the one who killed!"] = "Votez villageois! Désignez celui qui doit mourir!"
L["Rogue, wake up and do your sneaky thing!"] = "Réveil toi Voleur et réalise tes méfaits!"
L["Cupid, wake up and throw your arrows!"] = "Réveil toi Cupidon et propage l'Amour de tes flèches!"
L["Lovers, wake up and face your beloved!"] = "Réveillez vous Amants et regardez votre âme soeur!"
L["Seer, wake up and claim the real nature of one of your fellow!"] = "Réveillez vous Voyante et réclamez la vrai nature d'un de vos compagnons!"
L["Werewolves, wake up and eat, eat till your hunger are filled!"] = "Loups-garou, réveillez vous et mangez, mangez jusqu'à ce que votre faim disparaisse!"
L["Witch, wake up and decides with your potions!"] = "Réveillez vous Sorcière et décidez à l'aide de vos potions!"
L["You can not choose him twice"] = "Vous ne pouvez pas le choisir deux fois"
