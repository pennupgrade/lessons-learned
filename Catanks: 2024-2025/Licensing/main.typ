#import "@preview/unequivocal-ams:0.1.2": ams-article, proof, theorem
#import emoji:
#import "@preview/numbly:0.1.0": numbly

#set enum(full: true, numbering: numbly(
  "{1:1}.",
  "{2:a})",
  "{3:i}.",
))

#show ref: it => {
  link(it.target)[*#it*]
}

#let the_author = "exaCORE42"
#show link: set text(fill: blue)
#show: ams-article.with(
  title: [Lessons Learned: Licensing Unity Games],
  authors: (
    (
      name: the_author,
      // department: [Department of Mathematics],
      organization: [UPGRADE],
      location: [Philadelphia, PA, 19104],
    ),
  ),
  abstract: [After finishing development of #link("https://github.com/pennupgrade/couverture")[Catanks], UPGRADE was interested in releasing the game under an open source license.  However, due to lack of planning, this ended up being significantly harder than expected.  This paper will document what #the_author learned while licensing Catanks in the hopes that it will be useful for future UPGRADE games and other game development clubs.],
)

#let change_margin = -5em
#block(inset: (right: change_margin, left: change_margin))[

  *NOTE: I am not a lawyer.  This is not legal advice, just my current best understanding of copyright law and licensing.*

  = Choosing a License
  There are many different open source licenses to choose from.  When licensing Catanks, here is an overview of the options we considered.

  #[
    #show table.cell.where(y: 0): it => {
      set text(weight: "bold")
      it
    }
    #show table.cell.where(x: 1): it => {
      if it.y != 0 {
        if it.body == [y] [
          #show "y": [#emoji.checkmark.box]
          #it
        ] else if it.body == [n] [
          #show "n": [#emoji.crossmark]
          #it
        ] else [#it]
      } else {
        it
      }
    }
    #show table.cell.where(x: 0): it => {
      it
    }
    #table(
      columns: (2fr, 0.8fr, 4fr, 4fr),
      align: center + horizon,

      table.header([License], [Used?], [Key Features], [Reason Used/Not Used]),
      [#link("https://opensource.org/license/gpl-3-0")[GPLv3]],
      [n],
      [The GPLv3 license requires the entire project and any components to also be licensed under GPLv3 (or a #link("https://www.gnu.org/licenses/license-list.en.html")[compatible license]).],
      [Unity is not open source and thus, licensing any part of a Unity game under GPLv3 doesn't make sense because the terms of the license cannot be fulfilled.],

      [#link("https://opensource.org/license/mpl-2-0")[MPL 2.0]],
      [y],
      [The MPL 2.0 license ensures that any modifications to MPL licensed files must also be licensed under the MPL 2.0 license, but puts no licensing requirements on other files.],
      [We chose to license all UPGRADE-contributed script, shader, material, prefab, and animation files under this license because we wanted any modifications to our code to contribute back to the open source ecosystem.  Additionally, the MPL license allows our open source code to interface with the closed source game engine (Unity)],

      [#link("https://creativecommons.org/licenses/by-sa/4.0/")[CC BY-SA 4.0]],
      [y],
      [The CC BY-SA 4.0 license allows others to use the art but requires them to also license any modifications under the same license (or a compatible license).  Additionally, it requires that anyone who uses the art to give credit for producing the original work to the authors of the orginal work.],
      [We chose to license UPGRADE-contributed art is licesed under the CC BY-SA 4.0 license because it allows our art to be used freely, but ensures that credit is given to UPGRADE's artists.  Additionally, it ensures that any modifications to our art will contribute back to the open source ecosystem.],
    )
  ]

  = Before Development
  == License Agreement
  Before each person contributes code to the project for the first time, they should sign or agree to a licensing agreement that allows their work to be licensed under the chosen license(s).  An example license agreement can be found at @appendix-license-agreement.

  == Project Layout
  #let folder_name(name) = raw("Assets/" + name + "/")
  #let folder_name_original(folder) = folder_name(folder + "/original")
  #let folder_name_reused(folder) = folder_name(folder + "/reused")
  #let folder_setup(folder_types) = {
    for folder in folder_types [
      + #folder_name_original(folder)
      + #folder_name_reused(folder) \
    ]
  }
  Separating files by their type makes licensing much easier.  For Catanks, an example of a folder layout could be:
  #folder_setup(("Images", "Audio", "Models", "Prefabs", "Materials", "Shaders"))
  + #folder_name("Scripts")

  = Best Practices
  This section covers the best practices to follow as a Unity game is being developed to ensure that licensing is not a difficult process.  This section is mainly intended for developers.

  == Code
  Do not use code that you do not have the rights to license under your chosen open source license, such as:
  + Code that was distributed as part of a course
  + Code that you found on a forum or tutorial
  + Code that was authored in part or in full by a person who has not signed the license agreement

  See @reusing-code for cases when you would be allowed to use code that isn't your own and how to license it.

  == Art
  See @reusing-art for information about how to properly license and reuse art.
  === Sound Effects
  #figure(
    [
      #image("freesound-license.png", width: 60%)
    ],
    caption: [Licensing information for a sound on #link("https://freesound.org")[freesound.org]],
    placement: bottom,
  )
  + If you are making your own sound effects from scratch place them in #folder_name_original("Audio")
  + If you are not making your own sound effects, only use sounds from #link("https://freesound.org")[freesound.org] that are labelled as licensed under:
    + `Creative Commons 0`
    + `Attribution 4.0` (CC BY 4.0)
    + `Attribution 3.0` (CC BY 3.0) if needed, but preferably one of the above
  + If you use sounds from freesound.org as explained above, place each sound in its own folder (such as #raw(folder_name_reused("Audio").text + "<name of sound>/")).  In the folder, also include a text file that contains a link to the sound on freesound.org and a note about whether the sound was original sound was modified.
  === Music

  === Other Art

  = Reusing Code <reusing-code>

  = Reusing Art <reusing-art>

  = Appendix A (FINISH FORMATTING) <appendix-license-agreement>
]
