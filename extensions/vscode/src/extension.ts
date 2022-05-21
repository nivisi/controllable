import * as vscode from 'vscode';
import * as xcontroller from "./commands/create_controller";
import * as xmodule from "./commands/create_module";


export function activate(context: vscode.ExtensionContext) {
	context.subscriptions.push(
		vscode.commands.registerCommand("controllable-vscode-extensions.createModule", xmodule.createModule),
		vscode.commands.registerCommand("controllable-vscode-extensions.createController", xcontroller.createController),
	)
}

export function deactivate() { }
