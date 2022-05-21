import * as changeCase from 'change-case';
import { existsSync, writeFile } from 'fs';
import * as _ from 'lodash';
import * as mkdirp from 'mkdirp';
import {
    InputBoxOptions,
    OpenDialogOptions,
    window,
    workspace
} from 'vscode';

export function createDirectory(where: string): Promise<void> {
    return new Promise((resolve, reject) => {
        mkdirp(where).then((value) => {
            resolve()
        },
            (reason: any) => {
                reject(reason);
            });
    });
}

export function generateSnippet(
    filePath: string,
    fileName: string,
    snippet: string,
) {
    if (existsSync(filePath)) {
        throw Error(`${fileName} already exists`);
    }

    return new Promise<void>(async (resolve, reject) => {
        writeFile(
            filePath,
            snippet,
            'utf8',
            (error) => {
                if (error) {
                    reject(error);
                    return;
                }
                resolve();
            }
        );
    });
}

export function askToInputSnakeCased(
    hint: string,
    placeholder: string,

): Thenable<string | undefined> {
    const prompt: InputBoxOptions = {
        prompt: hint,
        placeHolder: placeholder,
        validateInput: (value): string => {
            let snakecased = changeCase.snakeCase(value);
            if (snakecased != value) {
                return 'Use snake_case, e.g. hello_world, main, settings_main';
            }

            return '';
        },
    };

    return window.showInputBox(prompt);
}

export async function askToSelectDirectory(
    title: string,
    openLabel: string,
) {
    const options: OpenDialogOptions = {
        title: title,
        openLabel: openLabel,
        canSelectMany: false,
        canSelectFolders: true,
    };

    const uri = await window.showOpenDialog(options);
    if (uri == null || _.isEmpty(uri)) {
        return undefined;
    }
    return uri[0].fsPath;
}

export function viewFile(filePath: string) {
    if (!existsSync(filePath)) {
        throw Error(`${filePath} does not exist`);
    }

    workspace.openTextDocument(filePath).then(doc => {
        window.showTextDocument(doc);
    }
    );
}
