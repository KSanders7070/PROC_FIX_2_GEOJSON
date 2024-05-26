# PROC_FIX_2_GEOJSON
Converts a list of fix IDs into two geojsons to be used with CRC, one for symbols and the other for the fix names.

Make a list of fix IDs like the one you see below that you want to make a fix and symbol geojson for.
```
HHOWE
BROKK
LNCON
```

Now, place the cursor at the end of each ID and hit your enter key to make a blank line betwee each like this:
```
HHOWE

BROKK

LNCON

```

For some reason, doing a find/replace with \n\n doesn't work.
Now, copy the contents including the last blank line to your computer clipboard.
Launch the batch file and type the name of the procedure.
Then paste the clipboard.
When complete, type DONE and enter, enter.

Open each newly created file and remove the comment and the last comma at near the end.

Save and good to go.
