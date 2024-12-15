classdef editSignal < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        chooseasignalDropDown       matlab.ui.control.DropDown
        chooseasignalDropDownLabel  matlab.ui.control.Label
        DoneButton                  matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DoneButton
        function DoneButtonPushed(app, event)
            delete(app);
        end

        % Value changed function: chooseasignalDropDown
        function chooseasignalDropDownValueChanged(app, event)
            value = app.chooseasignalDropDown.Value;
            assignin('base','operation',value);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 263 167];
            app.UIFigure.Name = 'MATLAB App';

            % Create DoneButton
            app.DoneButton = uibutton(app.UIFigure, 'push');
            app.DoneButton.ButtonPushedFcn = createCallbackFcn(app, @DoneButtonPushed, true);
            app.DoneButton.Position = [149 15 100 22];
            app.DoneButton.Text = 'Done ';

            % Create chooseasignalDropDownLabel
            app.chooseasignalDropDownLabel = uilabel(app.UIFigure);
            app.chooseasignalDropDownLabel.HorizontalAlignment = 'right';
            app.chooseasignalDropDownLabel.Position = [33 73 88 22];
            app.chooseasignalDropDownLabel.Text = 'choose a signal';

            % Create chooseasignalDropDown
            app.chooseasignalDropDown = uidropdown(app.UIFigure);
            app.chooseasignalDropDown.Items = {'choose', 'Amplituide Scaling', 'Time shift', 'Time reversal', 'Compression', 'Expansion'};
            app.chooseasignalDropDown.ValueChangedFcn = createCallbackFcn(app, @chooseasignalDropDownValueChanged, true);
            app.chooseasignalDropDown.Position = [132 73 100 22];
            app.chooseasignalDropDown.Value = 'choose';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = editSignal

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end