import * as changeCase from 'change-case';
import { existsSync, lstatSync } from 'fs';
import * as _ from 'lodash';
import {
    Uri,
    window,
    workspace
} from 'vscode';
import * as helpers from '../helpers/helpers';
import { controllerSnippet, effectSnippet, eventSnippet, stateSnippet } from './snippets/index';

export const createController = async (uri: Uri) => {
    const controllerName = await askControllerName();

    if (controllerName == null || controllerName.trim() === '') {
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
    }

    const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());

    try {
        const viewController = 'View controller';

        await generateControllerFiles(controllerName, folder!);
        const action = await window.showInformationMessage(
            `${pascalCaseName} controller was generated`,
            viewController,
        );

        if (action == viewController) {
            workspace.openTextDocument(
                `${folder}/controller/${controllerName}_controller.dart`).then(doc => {
                    window.showTextDocument(doc);
                }
                );
        }
    } catch (error) {
        window.showErrorMessage(
            `Failure:
            ${error instanceof Error ? error.message : JSON.stringify(error)}`
        );
    }
};

function askControllerName(): Thenable<string | undefined> {
    return helpers.askToInputSnakeCased(
        'Controller name',
        'hello_world',
    );
}

async function askForFolder(): Promise<string | undefined> {
    return helpers.askToSelectDirectory(
        'Select a folder to create a controller in',
        'Create the controller here',
    );
}

export async function generateControllerFiles(
    controllerName: string,
    folder: string,
) {
    const controllerFolderPath = `${folder}/controller`;

    if (!existsSync(controllerFolderPath)) {
        await helpers.createDirectory(controllerFolderPath);
    }

    const snakeCaseControllerName = changeCase.snakeCase(controllerName.toLowerCase());

    await Promise.all([
        generateController(snakeCaseControllerName, controllerFolderPath),
        generateState(snakeCaseControllerName, controllerFolderPath),
        generateEvent(snakeCaseControllerName, controllerFolderPath),
        generateEffect(snakeCaseControllerName, controllerFolderPath),
    ]);
}


function generateController(
    snakeCaseControllerName: string,
    folder: string,
) {
    const fileName = `${snakeCaseControllerName}_controller.dart`;
    const filePath = `${folder}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        controllerSnippet(snakeCaseControllerName),
    );
}

function generateState(
    snakeCaseControllerName: string,
    folder: string,
) {
    const fileName = `${snakeCaseControllerName}_state.dart`;
    const filePath = `${folder}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        stateSnippet(snakeCaseControllerName),
    );


}

function generateEvent(
    snakeCaseControllerName: string,
    folder: string,
) {
    const fileName = `${snakeCaseControllerName}_event.dart`;
    const filePath = `${folder}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        eventSnippet(snakeCaseControllerName),
    );


}

function generateEffect(
    snakeCaseControllerName: string,
    folder: string,
) {
    const fileName = `${snakeCaseControllerName}_effect.dart`;
    const filePath = `${folder}/${fileName}`;

    return helpers.generateSnippet(
        filePath,
        fileName,
        effectSnippet(snakeCaseControllerName),
    );

}
