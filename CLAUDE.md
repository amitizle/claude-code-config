# Claude Code configuration repository

## Description

This repository contains configuration files and guidelines for using Claude, an AI assistant developed by Anthropic, to assist with coding tasks. The goal is to provide a structured approach to leveraging Claude's capabilities while ensuring high-quality code that adheres to best practices.

## Features

There's a script, `setup.sh` which is using `stow` to symlink the configuration files into your home directory.
The script `setup.sh` is also downloading a few sub-agents and placing them in the `agents` directory in the target location.

There's a `claude-code` directory containing configuration files for Claude. The main file is `CLAUDE.md`, which outlines the workflow and standards for using Claude effectively.
Within the `claude-code` directory, there are:

  * `commands` directory, containing subdirectories for different categories of commands. Each category has one or more command files with specific instructions for Claude.
  * `scripts` directory, which includes utility scripts to facilitate interactions with Claude, for example for handling hooks.
  * `settings.json` file, which contains settings for Claude to follow during interactions.
  * `CLAUDE.md` file, which provides an overview of the workflow and best practices for using Claude.

There are Claude Code commands under

### Commands

#### `project-manager`

These are set of commands that helps you manage context per project. You may initialize a project, add context, and then use that context in your conversations with Claude.
The goal of these commands is to keep a context globally within the system and is meant to manage a long term memory for Claude.
