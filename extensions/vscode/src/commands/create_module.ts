import * as changeCase from 'change-case';
import { existsSync, lstatSync } from 'fs';
import * as _ from 'lodash';
import {
    Uri,
    window
} from 'vscode';
import * as helpers from '../helpers/helpers';
import { generateControllerFiles } from './create_controller';
import { bodySnippet, listenerSnippet, pageSnippet } from './snippets/index';

export const createModule = async (uri: Uri) => {
    const moduleName = await askModuleName();

    if (moduleName == null || moduleName.trim() === '') {
        window.showErrorMessage('The name must not be empty');
        return;
    }

    var folder: string | undefined;

    if (_.isNil(_.get(uri, 'fsPath')) || !lstatSync(uri.fsPath).isDirectory()) {
        folder = await askForFolder();
        if (_.isNil(folder)) {
            window.showErrorMessage('Please select a valid folder');
            return;
        }
    } else {
        folder = uri.fsPath;
        var parts = folder.split('/');
        var last = parts[parts.length - 1];
        if (last != moduleName) {
            folder = `${folder}/${moduleName}`;
        }
    }

    const pascalCaseName = changeCase.pascalCase(moduleName.toLowerCase());

    try {
        const viewController = 'View controller';

        await generateModuleFiles(moduleName, folder!);
        const action = await window.showInformationMessage(
            `${pascalCaseName} module was generated`,
            viewController,
        );

        if (action == viewController) {
            helpers.viewFile(`${folder}/controller/${moduleName}_controller.dart`);
        }
    } catch (error) {
        window.showErrorMessage(
            `Failure:
            ${error instanceof Error ? error.message : JSON.stringify(error)}`
        );
    }
};

function askModuleName(): Thenable<string | undefined> {
    return helpers.askToInputSnakeCased(
        'Module name',
        'hello_world',
    );
}

async function askForFolder(): Promise<string | undefined> {
    return helpers.askToSelectDirectory(
        'Select a folder to create a module in',
        'Create the module here',
    );
}

async function generateModuleFiles(
    moduleName: string,
    folder: string,
) {
    const uiFolderPath = `${folder}/ui`;

    if (!existsSync(uiFolderPath)) {
        await helpers.createDirectory(uiFolderPath);
    }

    const snakeCaseModuleName = changeCase.snakeCase(moduleName.toLowerCase());

    await Promise.all([
        generateControllerFiles(moduleName, folder),
        generatePage(snakeCaseModuleName, uiFolderPath),
        generateBody(snakeCaseModuleName, uiFolderPath),
        generateListener(snakeCaseModuleName, uiFolderPath),
    ]);
}

function generatePage(
    snakeCaseModuleName: string,
    folderPath: string,
) {
    const fileName = `${snakeCaseModuleName}_page.dart`;
    const filePath = `${folderPath}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        pageSnippet(snakeCaseModuleName),
    );
}


function generateBody(
    snakeCaseModuleName: string,
    folderPath: string,
) {
    const fileName = `${snakeCaseModuleName}_body.dart`;
    const filePath = `${folderPath}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        bodySnippet(snakeCaseModuleName),
    );
}

function generateListener(
    snakeCaseModuleName: string,
    folderPath: string,
) {
    const fileName = `${snakeCaseModuleName}_listener.dart`;
    const filePath = `${folderPath}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        listenerSnippet(snakeCaseModuleName),
    );
}
