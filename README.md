# bookmarks.sh

A simple command-line utility to bookmark directories.

![screenshot][screenshot]

## Demo

![bookmarks_dot_sh_demo][demo]

## Motivation

-   I was tired of `cd`'ing into my frequently visited directories by typing/tab completing the complete path every time.
-   I wanted to write some shell script :smile:.

## Dependencies

|      |                                                     |
| ---- | --------------------------------------------------- |
| grep | for searching directories in bookmarks.txt file     |
| sed  | for deleting directory from bookmarks.txt file      |
| fzf  | for fuzzy-finding directories in bookmarks.txt file |

## Install instructions

-   Copy `bookmarks.sh` file somewhere in your `$PATH`, and make it executable. (I keep the script in `~/.local/bin`)

    for example:

    ```sh
    wget https://raw.githubusercontent.com/krish-r/bookmarks.sh/main/bookmarks.sh -O ~/.local/bin/bookmarks.sh

    # adds executable permission to user
    chmod u+x ~/.local/bin/bookmarks.sh
    ```

## Uninstall instructions

-   Simply remove the script from your path and the bookmark file.

    for example:

    ```sh
        rm -i $(which bookmarks.sh)

        # The file where the bookmarks will be stored.
        rm -i ~/.cache/bookmarks.txt
    ```

## Options

### view help

```sh
bookmarks.sh
bookmarks.sh -h
```

### `add` a directory to bookmarks

```sh
# add current directory to bookmarks
bookmarks.sh -a

# add a custom directory to bookmarks
# you can use "~" or "$HOME" to specify your home directory
bookmarks.sh -a "full_path_to_your_directory_within_double_quotes"
```

**Note**: Relative paths are not supported

### `delete` a directory from bookmarks

```sh
# delete current directory from bookmarks
bookmarks.sh -d

# delete a custom directory from bookmarks
bookmarks.sh -d "full_path_to_your_directory_within_double_quotes"
```

### `list` and fzf the bookmarked directories

```sh
bookmarks.sh -l
```

### `cd` to a bookmarked directory

```sh
cd $(bookmarks.sh -l)
```

## Aliases

Add these aliases in your `.bashrc` or `.zshrc` or wherever you manage your aliases.

```sh
if command -v bookmarks.sh &> /dev/null; then
    alias badd="bookmarks.sh -a"
    alias bdel="bookmarks.sh -d"
    alias blist='eval cd $(bookmarks.sh -l)' # use single quotes to evaluate
fi
```

[screenshot]: https://user-images.githubusercontent.com/54745129/204101118-ee1de797-93fe-4b3a-b962-3804978f0789.png
[demo]: https://user-images.githubusercontent.com/54745129/204107707-543c3d82-b6f1-4eaa-af87-b9027a4ed0fe.gif
