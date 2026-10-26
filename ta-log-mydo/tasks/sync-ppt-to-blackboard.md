# Blackboard Documents Upload - 6920

- Status: Done
- Created: Oct 26, 2026, 3:40 PM
- Started: Oct 26, 2026, 3:40 PM
- Finished: Oct 26, 2026, 3:56 PM
- Time worked: 15m 56s (1 session)
- Break time: 0s (0 breaks)
- Start to finish: 15m 56s

## Work sessions

1. Oct 26, 2026, 3:40 PM → 3:56 PM · 15m 56s

## Breaks

None.

## Log

Oct 26, 2026, 3:40 PM · Timer started · 25m countdown
Oct 26, 2026, 3:40 PM · Note from the dr A: add it to each corresponding folder
Oct 26, 2026, 3:47 PM · Used the claude for rename the chapter, this are title for the chapters. so and my file names, are like this in the folder, ch-01-PPTaccessible.ppt, so i neefd to rename as per the chapter names, so give me the rename.sh file. it takes all this files from 1-9 and renames it lie this. ch-01-name-of-the-chapter.pptx  - prompt
Oct 26, 2026, 3:47 PM · code. #!/usr/bin/env bash
    # Renames ch-01-*.ppt(x) ... ch-09-*.ppt(x) to ch-NN-chapter-name.<same ext>
    # Run it inside the folder with the files.
    # Preview first:  DRY_RUN=1 ./rename.sh
    
    names=(
      ""
      "introduction-information-systems-and-people"
      "information-systems-and-strategy"
      "ict-enterprise-architecture-cloud-5g-etc"
      "databases-and-data-warehouses-sql-blockchain"
      "enterprise-systems-erp-crm-scm"
      "digital-presence-web-social-media-mobile-apps"
      "business-intelligence-and-analytics-ai-chatgpt"
      "collaboration-technologies-and-metaverse"
      "knowledge-management-and-e-learning"
    )
    
    for i in 1 2 3 4 5 6 7 8 9; do
      num=$(printf "%02d" "$i")
      found=0
      for f in ch-"$num"-*.ppt ch-"$num"-*.pptx; do
        [ -e "$f" ] || continue
        found=1
        ext="${f##*.}"
        new="ch-${num}-${names[$i]}.${ext}"
        if [ "$f" = "$new" ]; then
          echo "skip (already named): $f"
          continue
        fi
        if [ -n "$DRY_RUN" ]; then
          echo "would rename: $f -> $new"
        else
          mv -n -- "$f" "$new" && echo "renamed: $f -> $new"
        fi
      done
      [ "$found" -eq 0 ] && echo "not found: ch-${num}-*"
    done
Oct 26, 2026, 3:48 PM · AI: I wrote `rename.sh`. Put it in the folder with your files and run `chmod +x rename.sh && ./rename.sh`. To preview first, run `DRY_RUN=1 ./rename.sh`.
    
    It renames `ch-01-*` through `ch-09-*` to names like `ch-01-introduction-information-systems-and-people`. The names are lowercase with hyphens, and the brackets, commas and `&` are dropped.
    
    One question: your files end in `.ppt`, but you want `.pptx`. Renaming the extension alone doesn't convert the file, and PowerPoint can refuse to open it. So the script keeps whatever extension each file already has. If they really are old `.ppt` files and you need `.pptx`, I can add a LibreOffice convert step to the script. Which do you want?
Oct 26, 2026, 3:48 PM · (base) TS22519:files ssharma33$ ls
    ch-01-PPTaccessible.pptx	ch-08-PPTaccessible.pptx
    ch-02-PPTaccessible.pptx	ch-09-PPTaccessible.pptx
    ch-03-PPTaccessible.pptx	ch-10-PPTaccessible.pptx
    ch-04-PPTaccessible.pptx	ch-11-PPTaccessible.pptx
    ch-05-PPTaccessible.pptx	ch-12-PPTaccessible.pptx
    ch-06-PPTaccessible.pptx	rename.sh
    ch-07-PPTaccessible.pptx
    (base) TS22519:files ssharma33$
Oct 26, 2026, 3:49 PM · after, (base) TS22519:files ssharma33$ ls
    ch-01-introduction-information-systems-and-people.pptx
    ch-02-information-systems-and-strategy.pptx
    ch-03-ict-enterprise-architecture-cloud-5g-etc.pptx
    ch-04-databases-and-data-warehouses-sql-blockchain.pptx
    ch-05-enterprise-systems-erp-crm-scm.pptx
    ch-06-digital-presence-web-social-media-mobile-apps.pptx
    ch-07-business-intelligence-and-analytics-ai-chatgpt.pptx
    ch-08-collaboration-technologies-and-metaverse.pptx
    ch-09-knowledge-management-and-e-learning.pptx
Oct 26, 2026, 3:49 PM · now i can open those two fiels local and the blackboard side by side and drag and drop.
Oct 26, 2026, 3:55 PM · Dragged all the respective files under the class topics.
Oct 26, 2026, 3:55 PM · All the accessibility scores are good, for all the 9 files form ch1-ch9. the chj 10 11 and 12 are not in the blackboard.
Oct 26, 2026, 3:56 PM · Timer stopped · 15m
Oct 26, 2026, 3:56 PM · Marked done
