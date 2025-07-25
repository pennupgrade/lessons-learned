#import "@preview/unequivocal-ams:0.1.2": ams-article, proof, theorem
#import emoji: checkmark, crossmark
#import "@preview/numbly:0.1.0": numbly
#import "@preview/gentle-clues:1.2.0": *
#let code_example(content) = block(
  pad(
    content,
    0.5em,
  ),
  fill: luma(220),
  width: 100%,
)

#set enum(full: true, numbering: numbly(
  "{1:1}.",
  "{2:a})",
  "{3:i}.",
))

#let lincmd(string) = {
  let pad_amt_y = 0.5em
  let pad_amt_x = 0.5em
  let pad_txt(it) = pad(top: pad_amt_y, bottom: pad_amt_y, left: pad_amt_x, it)
  block(pad_txt(raw("$ " + string)), fill: luma(230), width: 100%)
}
#let rlink(goto) = link(goto.target)[*#goto*]

#let yes_no_table(the_table, used_col_num) = [
  #show table.cell.where(y: 0): it => {
    set text(weight: "bold")
    it
  }
  #show table.cell.where(x: used_col_num): it => {
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
  #the_table
]

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

  #warning[*I am not a lawyer.  This is not legal advice, just my current best understanding of copyright law and licensing.*]

  = Choosing a License
  There are many different open source licenses to choose from.  When licensing Catanks, here is an overview of the options we considered.

  #yes_no_table(
    table(
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
    ),
    1,
  )

  = Before Development
  == License Agreement
  Before each person contributes code to the project for the first time, they should sign or agree to a licensing agreement that allows their work to be licensed under the chosen license(s).  An example license agreement can be found at #rlink[@appendix-license-agreement].

  == Project Layout
  #let folder_name(name) = raw("Assets/" + name + "/")
  #let folder_name_original(folder, suffix: "") = raw(folder_name(folder + "/original").text + suffix)
  #let folder_name_reused(folder, suffix: "") = raw(folder_name(folder + "/reused").text + suffix)
  #let folder_setup(folder_types) = {
    for folder in folder_types [
      + #folder_name_original(folder)
      + #folder_name_reused(folder) \
    ]
  }
  Separating files by their type makes licensing much easier.  For Catanks, an example of a folder layout could be:
  #folder_setup(("Images", "Audio", "Models", "Materials", "Shaders"))
  + #folder_name("Scripts")
  + #folder_name("Prefabs")

  = Best Practices
  This section covers the best practices to follow as a Unity game is being developed to ensure that licensing is not a difficult process.  This section is mainly intended to help developers ensure that the content that they use is easily able to be licensed at the end of development.

  #notify[If you want to use content from a previous UPGRADE game, ensure that the game has been properly licensed.  So far, the only game that meets that criteria is Catanks.  Further instructions about how to use previous UPGRADE content are in the sections below.<properly-licensed-upgrade>]

  #warning[
    Even if a site advertises "royalty free" art or free to use code, oftentimes, that does not mean that one can release it under an open source license.]

  == Code
  Do not use code that you do not have the rights to license under your chosen open source license, such as:
  + Code that was distributed as part of a course
  + Code that you found on a forum or tutorial
  + Code that was authored in part or in full by a person who has not signed the license agreement

  See #rlink[@reusing-code] for cases when you would be allowed to use code that isn't your own and how to license it.

  == Art
  See #rlink[@reusing-art] for information about how to properly license art.

  To use art (or shaders) from a #link(<properly-licensed-upgrade>)[properly licensed UPGRADE game], place the art in the directory #folder_name_reused("<type of art>", suffix: "<filename>")) and include a text file with a link to the file on Github in that directory.
  === Sound Effects
  + If you are making your own sound effects from scratch place them in #folder_name_original("Audio")
  + If you are not making your own sound effects, only use sounds from #link("https://freesound.org")[freesound.org].  Make sure that any sounds you use are licensed under (see #rlink[@freesound_licensing_loc] for where to look for this information):
    + `Creative Commons 0`
    + `Attribution 4.0` (CC BY 4.0)
    + `Attribution 3.0` (CC BY 3.0) if needed, but preferably one of the above
  + If you use sounds from freesound.org as explained above, place each sound in its own folder (such as #folder_name_reused("Audio", suffix: "<name of sound>/").  In the folder, also include a text file that contains a link to the sound on freesound.org and a note about whether the original sound was modified.
  #figure(
    [
      #image("freesound-license.png", width: 60%)
    ],
    caption: [Licensing information for a sound on #link("https://freesound.org")[freesound.org]],
  )<freesound_licensing_loc>
  === Music
  For Catanks, all the music was created by UPGRADE members and placed in the #folder_name_original("Audio") directory.
  === Other Art
  For other art including 3D models and 2D images, only use UPGRADE made art.
  === Fonts
  Only use open source fonts.  I recomment only using #link("https://fonts.google.com/")[Google Fonts] to find fonts (they only have open source fonts and it is easy to locate the fonts' license during the licensing process).

  = Licensing Tools: REUSE
  In order to license Catanks, we used an open source tool called #link("https://reuse.software")[REUSE].  REUSE made it easy to license all the files in the project and provides a tool to check compliance with the #link("https://reuse.software/spec/")[REUSE specification].  This section will cover how to use the #link("https://github.com/fsfe/reuse-tool")[REUSE tool].  This will be important to understand in the following sections.

  REUSE is a system that makes licensing much easier by either including licensing information with the source files or specifying it in the `REUSE.toml` file.  I highly recommend reading REUSE's #link("https://reuse.software/tutorial/")[tutorial], #link("https://reuse.software/faq/")[FAQ], and #link("https://reuse.readthedocs.io/en/stable/index.html")[documentation].

  == How does REUSE work
  The central idea of REUSE is to store all the licenses for the project in a single location: the `Licenses` directory.  There are 3 ways for files to be licensed according to the REUSE specification:
  + Directly in the file using comment headers #footnote[Recommended method for source code files: #link("https://reuse.software/faq/#why-care")]<why-comment-headers>
  + Next to the file using `.license` files #footnote[#link("https://reuse.software/faq/#uncommentable-file")]
  + In the `REUSE.toml` file

  == Licensing Methods Used
  #yes_no_table(
    table(
      align: center + horizon,
      columns: (1.2fr, 0.7fr, 1fr, 2fr),
      table.header([Licensing Method], [Used?], [Files Used For], [Reason Used/Not Used]),
      [Comment Headers],
      [y],
      [Most script files],
      [Convenient for future users of the code and portable @why-comment-headers],

      [`.license` Files],
      [n],
      [*---*],
      [For every file in the `Assets/` directory, Unity adds a corresponding `.meta` file.  If we added a `.license` file for nearly every asset file, Unity would add thousands of `.meta` files which would clutter up the repository.  Additionally, Unity allows assets to be moved within it's editor easily, but doing so would leave behind old `.license` files.],

      [`REUSE.toml`],
      [y],
      [Art, shaders, some script files, material files, animation files, models, images, fonts],
      [Allowed for bulk licensing #footnote([#link("https://reuse.software/faq/#bulk-licenses")]) of files. Is a centralized location for tracking the many different licenses used in the project.],
    ),
    1,
  )

  == Comment Headers
  The general format for comment headers in `.cs` files is:
  #code_example[
    ```
    // SPDX-FileCopyrightText: <year> <copyright holder>
    //
    // SPDX-License-Identifier: <SPDX license>
    ```
  ]
  However, one generally shouldn't add these comment headers manually.  The REUSE tool has an #link("https://reuse.readthedocs.io/en/stable/man/reuse-annotate.html")[easy way] to add comment headers to files.
  #notify[
    Currently, REUSE tool does not have a way to modify or delete headers, so be careful!
  ]

  == `REUSE.toml` File
  The format for a `REUSE.toml` file entry is:
  #code_example[
    ```
    [[annotations]]
    path = [<list of files>]
    precedence = "override"
    SPDX-FileCopyrightText = [<list of copyright text>]
    SPDX-License-Identifier = <SPDX license code>
    ```
  ]
  The precedence doesn't have to be `override`, there are other options, but to keep things simple when licensing, you should use `override`.  Check out #link("")[Catanks' `REUSE.toml`] for an example.

  #tip[The path string(s) can use globbing to match many files at once.#footnote[#link("https://reuse.software/spec-3.3/#reusetoml")]<reuse-toml-reuse-spec>]
  #info[
    The last `[[annotation]]` in the `REUSE.toml` to cover a file is the one to define the licensing information for that file.@reuse-toml-reuse-spec
  ]

  For more information about `REUSE.toml`, see the #link("https://reuse.software/spec/")[REUSE specification].

  == `.gitignore`
  The REUSE tool ignores files that are not in the git repository and and in the `.gitignore` file.#footnote[#link("https://reuse.software/faq/#exclude-file")]

  = Licensing Tips
  == Contributors as a Group
  In Catanks, since we had many contributors, instead of having a copyright notice for each person who contributed to a file, we included a single copyright notice with the author as `The Catanks Contributors` and a file in the at the root of the repository called #link("https://github.com/pennupgrade/couverture/blob/sublevel1-merge/CONTRIBUTORS.md")[`CONTRIBUTORS.md`] that listed all the contributors.  This is a valid way to do copyright notices according to REUSE.#footnote[#link("https://reuse.software/faq/#many-copyright-statements")]

  == Custom Licenses <custom-license>
  To use custom licenses with REUSE, one can place their own license in the `LICENSES/` directory with the name `LicenseRef-<name>.txt`.  This license can  be referenced with the SPDX license code `LicenseRef-<name>`.#footnote[#link("https://reuse.software/faq/#custom-license")]

  == Configuration Files
  Copyright protection only applies to "orginal works of authorship" #footnote[#link("https://reuse.software/faq/#what-is-copyrightable")] where free choices were made about how to create the work. #footnote[#link("https://fsfe.org/news/2025/news-20250515-01.html")]<fsfe-news-copyrightable>  Therefore, it follows that many config files present in Unity projects are not copyrightable. @fsfe-news-copyrightable#super[,~]#footnote[#link("https://reuse.software/faq/#uncopyrightable")]<license-uncopyrightable>  There are a few ways to deal with these config files.  Catanks chose to license them under the license used for source code files, as explained by the #link("https://reuse.software/faq/#uncopyrightable")[advice given by REUSE]

  = Reusing Code <reusing-code>
  == What Code Are You Allowed To Use <reuse-code-legal>
  If you want to use someone else's code, you must ensure that the license they published their code under is compatible with the license your code will be published under.  Additionally, certain licenses may come with extra stipulations

  === MIT/BSD Licenses
  Certain licenses such as the MIT and BSD licenses require those who use the code to keep a verbatim  copy of the license text in their repository somewhere.  Oftentimes, this text includes a copyright statement with the author's name.  Catanks followed one of the options outlined by REUSE#footnote[#link("https://reuse.software/faq/#license-templates")] and included the license text as a #link(<custom-license>)[custom license] and referenced it when necessary.

  == Licensing Code

  #notify[
    Make sure to identify *all* copyright holders in the copright text(s) when licensing (see sections below for examples).
  ]

  === Using Comment Headers
  When licensing a file that uses someone else's code that you are allowed to use (see #rlink([@reuse-code-legal])), make sure to include a `SPDX-FileCopyrightText` tag for the original author and a `SPDX-License-Identifier` tag for the license the original code was distributed under in addition to those tags for your contributions.#footnote[#link("https://reuse.software/faq/#copy-work")]  For example:
  #code_example[
    ```
    // SPDX-FileCopyrightText: 2019 Sebastian Lague
    // SPDX-FileCopyrightText: 2024 The Catanks Contributors
    //
    // SPDX-License-Identifier: LicenseRef-MIT-PathCreator
    // SPDX-License-Identifier: MPL-2.0
    ```
  ]
  === Using `REUSE.toml`
  #warning[TODO: FINISH]


  = Licensing Art <reusing-art>
  == UPGRADE-Contributed Art
  Licensing original art created by UPGRADE for Catanks was very easy due to the license agreement.  We simply used the `REUSE.toml` file to license all the art under the `CC BY-SA 4.0` license.  Here is an example annotation we used to do this:
  #code_example[
    ```
    [[annotations]]
    path = [
      "Tanks/Assets/Models/**",
      "Tanks/Assets/Images/**",
      "AchievementsWithBorders/**",
      "Tanks/Assets/Audio/CustomSoundEffects/**",
      "Tanks/Assets/Audio/OfficialTracks/**"
      ]
    precedence = "override"
    SPDX-FileCopyrightText = "2024 The Catanks Contributors"
    SPDX-License-Identifier = "CC-BY-SA-4.0"
    ```
  ]

  == Reused Art: CC0
  To reuse art that is licensed under `CC0`, no attribution is needed.  However, I did include links to all art used in the `README`.  In order to make licensing easier, in the `REUSE.toml`, I marked the copyright holders as `NOASSERTION`:
  #code_example[
    ```
    [[annotations]]
    path = ["Tanks/Assets/Audio/OpenSourceSounds/CC0/**"]
    precedence = "override"
    SPDX-FileCopyrightText = "NOASSERTION"
    SPDX-License-Identifier = "CC0-1.0"
    ```
  ]

  == Reused Art: CC BY 3.0 and 4.0
  == No Modifications Made
  If no modifications are made, you *must* include the file in the `REUSE.toml` under the license it was released under.  Additionally, there must be a note included that gives attribution.  I used the #link("https://spdx.github.io/spdx-spec/v2.3/file-information/")[SPDX-FileNotice] tag for this.  Here is an example `REUSE.toml` annotation:
  #code_example[
    ```
    [[annotations]]
    path="Tanks/Assets/Audio/OpenSourceSounds/Other/bounce.wav"
    precedence = "override"
    SPDX-FileCopyrightText = ["NoiseCollector"]
    SPDX-License-Identifier = "CC-BY-3.0"
    SPDX-FileNotice = "Audio by NoiseCollector -- https://freesound.org/s/111361/ -- License: Attribution 3.0"
    ```
  ]

  == Modifications Made
  === Original Licensed Under `CC BY 4.0`
  If modifications are made to art originally licensed under `CC BY 4.0`, one can license the new work under `CC BY-SA 4.0`.#footnote[#link("https://opensource.stackexchange.com/a/12364")]<cc-by-to-cc-by-sa>  However, attribution to the original must be included in the `REUSE.toml`.  Here is an example of one such `REUSE.toml` annotation:
  #code_example[
    ```
    [[annotations]]
    path="Tanks/Assets/Audio/OpenSourceSounds/Other/mechanical-gadget.mp3"
    precedence = "override"
    SPDX-FileCopyrightText = ["2024 The Catanks Contributors", "kiddpark"]
    SPDX-License-Identifier = "CC-BY-SA-4.0"
    SPDX-FileNotice = "Audio modified by The Catank Contributors.\nOriginal audio made by kiddpark, licensed under CC-BY-4.0: https://freesound.org/s/201159/"
    ```
  ]
  === Original Licensed Under `CC BY 3.0`
  For art originally licensed under `CC BY 3.0`, there are two options:
  + License final work under `CC BY 3.0`
  + License modifications under `CC BY-SA 4.0`.  Meaning that the final work will be licensed under `CC BY-SA 4.0` and `CC BY 3.0` *IS THIS TRUE?!?!?!*
  = Reusing Fonts
  == Open Font License (OFL)
  === Reserved Name
  === `.asset` File Derived From the Font

  = Licensing Gotchas
  == TextMeshPro

  = Appendix A (FINISH FORMATTING) <appendix-license-agreement>
]
