import React, { useState, useEffect, useRef } from 'react';
import {
  SafeAreaView,
  View,
  Text,
  TextInput,
  StyleSheet,
  StatusBar,
  Platform,
  Linking,
  FlatList, // <-- UPGRADED for smooth scrolling
  KeyboardAvoidingView, // <-- ADDED to prevent keyboard issues
} from 'react-native';

// --- Configuration Object ---
const config = {
  username: 'root',
  hostname: 'orbit',
  lastBootTime: new Date(),
  systemInfo: {
    os: 'OrbitOS',
    version: '3.5.1 - mobile',
    kernel: '5.4.2-1070-gki',
    architecture: Platform.OS === 'android' ? 'aarch64' : 'x86_64',
  },
  batteryInfo: {
    percentage: Math.floor(Math.random() * 100) + 1,
    charging: Math.random() > 0.5,
  },
  dynamicStorage: {},
};

// --- Helper Functions ---
const getUptime = () => {
  const diff = new Date() - config.lastBootTime;
  let minutes = Math.floor(diff / 60000);
  let hours = Math.floor(minutes / 60);
  let days = Math.floor(hours / 24);
  let uptimeString = '';
  if (days > 0) uptimeString += `${days}d `;
  if (hours > 0) uptimeString += `${hours % 24}h `;
  uptimeString += `${minutes % 60}m`;
  return uptimeString;
};

const generateDynamicStorage = () => {
    config.dynamicStorage = {
        totalDisk: Math.floor(Math.random() * 401) + 100, 
        freeDisk: Math.floor(Math.random() * 201) + 50,
        totalRAM: [8, 12, 16, 32][Math.floor(Math.random() * 4)], 
        freeRAM: Math.floor(Math.random() * 4) + 1
    };
};

const generateRandomWeather = () => {
    const locations = [ { city: "Tokyo", country: "Japan" }, { city: "London", country: "UK" }, { city: "New York", country: "USA" }, { city: "Sydney", country: "Australia" }, { city: "Bucharest", country: "Romania" } ];
    const conditions = [ "Clear skies", "Partly cloudy", "Overcast", "Light rain", "Heavy rain", "Thunderstorm", "Foggy", "Snowing", "Sunny", "Windy" ];
    const location = locations[Math.floor(Math.random() * locations.length)];
    const condition = conditions[Math.floor(Math.random() * conditions.length)];
    return {
        location, condition,
        temperature: Math.floor(Math.random() * 51) - 10,
        humidity: Math.floor(Math.random() * 76) + 20,
        windSpeed: Math.floor(Math.random() * 51),
    };
};


// --- Main App Component ---
const App = () => {
  const [output, setOutput] = useState([]);
  const [input, setInput] = useState('');
  const [commandHistory, setCommandHistory] = useState([]);
  const [historyIndex, setHistoryIndex] = useState(-1);
  const [isSystemBricked, setSystemBricked] = useState(false);
  const [fontFamily, setFontFamily] = useState('monospace');

  const flatListRef = useRef(null);
  const inputRef = useRef(null);
  
  const promptSymbol = `${config.username}@${config.hostname}:~$ `;

  // --- Command Definitions ---
  const commands = {
    help: () => [
      { style: 'highlight', text: 'Available Commands:' },
      { text: 'help           - Shows this help message' },
      { text: 'fonts          - Change the terminal font' },
      { text: 'clear          - Clears the terminal screen' },
      { text: 'echo [text]    - Prints the specified text' },
      { text: 'date           - Shows current date and time' },
      { text: 'neofetch       - Displays system information' },
      { text: 'whoami         - Shows current user' },
      { text: 'history        - Shows command history' },
      { text: 'battery        - Shows battery status' },
      { text: 'software       - Shows system changelog' },
      { text: 'weather        - Shows weather information' },
      { text: 'processes      - Lists running processes' },
      { text: 'calc [expr]    - Calculate mathematical expression' },
      { text: 'browser [url]  - Opens a URL in the device browser' },
      { text: 'fortune        - Get a random fortune message' },
      { text: 'cowsay [text]  - Display a cow saying your message' },
      { text: 'reboot         - Reboots OrbitOS' },
    ],

    fonts: (args) => {
        const fontMap = {
            '1': 'monospace',
            '2': Platform.OS === 'ios' ? 'Courier New' : 'sans-serif-monospace',
            '3': 'sans-serif',
        };
        const fontNumber = args.trim();
        if (!fontNumber || !fontMap[fontNumber]) {
            return [
                { text: 'Available fonts:' },
                { text: '1. Default Monospace' },
                { text: '2. System Monospace' },
                { text: '3. System Sans-Serif' },
                { text: 'Usage: fonts [number]' },
            ];
        }
        setFontFamily(fontMap[fontNumber]);
        return [{ text: 'Font updated successfully.' }];
    },
    
    clear: () => {
      setOutput([]);
      return [];
    },

    echo: (args) => [{ text: args || 'Nothing to echo.' }],
    
    date: () => [{ text: new Date().toLocaleString('ro-RO', { dateStyle: 'full', timeStyle: 'long' }) }],
    
    neofetch: () => {
        const { totalDisk, freeDisk, totalRAM, freeRAM } = config.dynamicStorage;
        const art = `
              /\\
             /  \\
            /    \\
           /      \\
          /   ◢◤   \\
         /    ||    \\
        /     ||     \\
       /      ||      \\
      /________________\\
        `;
        return [
            { text: art, style: 'highlight', preformatted: true },
            { text: `${config.systemInfo.os}@${config.username}`, style: 'highlight' },
            { text: '-----------------' },
            { text: `OS: ${config.systemInfo.os} ${config.systemInfo.version}` },
            { text: `Kernel: ${config.systemInfo.kernel}` },
            { text: `Architecture: ${config.systemInfo.architecture}` },
            { text: `Total Disk: ${totalDisk.toFixed(2)} GB (${freeDisk.toFixed(2)} GB free)` },
            { text: `Total RAM: ${totalRAM.toFixed(2)} GB (${freeRAM.toFixed(2)} GB free)` },
            { text: `Uptime: ${getUptime()}` },
        ];
    },
    
    whoami: () => [{ text: `${config.username}@${config.hostname}`, style: 'highlight' }],
    
    history: () => {
      if (commandHistory.length === 0) return [{ text: 'No command history yet.' }];
      return commandHistory.map((cmd, i) => ({ text: `${i + 1}. ${cmd}` }));
    },

    battery: () => {
        const { percentage, charging } = config.batteryInfo;
        const timeRemaining = charging ? 
            `${Math.floor((100 - percentage) * 1.5 / 60)}h ${Math.floor(((100 - percentage) * 1.5) % 60)}m until full` :
            `${Math.floor(percentage * 8 / 60)}h ${Math.floor((percentage * 8) % 60)}m remaining`;

        return [
            { text: 'Battery Status:' },
            { text: `Charge: ${percentage}%` },
            { text: `Status: ${charging ? 'Charging' : 'Discharging'}` },
            { text: `Time ${charging ? 'to full' : 'remaining'}: ${percentage === 100 && charging ? 'Fully Charged' : timeRemaining}` },
        ];
    },

    software: () => {
        return { action: 'async', type: 'software_update' };
    },
    
    weather: () => {
        const weather = generateRandomWeather();
        return [
            { text: 'Current Weather:', style: 'highlight' },
            { text: `Location: ${weather.location.city}, ${weather.location.country}` },
            { text: `Temperature: ${weather.temperature}°C` },
            { text: `Condition: ${weather.condition}` },
            { text: `Humidity: ${weather.humidity}%` },
            { text: `Wind Speed: ${weather.windSpeed} km/h` },
        ];
    },
    
    processes: () => [
        { text: 'Running Processes:', style: 'highlight' },
        { text: '1. system_core    (PID: 1)' },
        { text: '2. terminal_app   (PID: 245)' },
        { text: '3. user_session   (PID: 892)' },
    ],
    
    calc: (args) => {
        try {
            if (!args) return [{ text: "Usage: calc [expression]" }];
            const safeArgs = args.replace(/[^-()\d/*+.]/g, '');
            if (!safeArgs) return [{ text: 'Error: Invalid characters in expression', style: 'error' }];
            const result = new Function(`return ${safeArgs}`)();
            return [{ text: `Result: ${result}` }];
        } catch (error) {
            return [{ text: 'Error: Invalid expression or calculation failed', style: 'error' }];
        }
    },
    
    browser: (args) => {
        const url = args.trim();
        if (!url) return [{ text: 'Usage: browser [url]' }];
        const fullUrl = (url.startsWith('http://') || url.startsWith('https://')) ? url : `https://${url}`;
        Linking.openURL(fullUrl).catch(err => console.error("Couldn't load page", err));
        return [{ text: `Opening ${fullUrl} in your device's browser...` }];
    },
    
    fortune: () => {
        const fortunes = ["You will find a hidden treasure.", "A beautiful, smart, and loving person will be coming into your life.", "Your hard work is about to pay off.", "A faithful friend is a strong defense."];
        return [ { text: "Fortune says:", style: 'highlight' }, { text: fortunes[Math.floor(Math.random() * fortunes.length)] } ];
    },
    
    cowsay: (args) => {
        const message = args.trim() || "Moo!";
        const bubbleWidth = message.length + 2;
        const topLine = ` ${'_'.repeat(bubbleWidth)} `;
        const bottomLine = ` ${'-'.repeat(bubbleWidth)} `;
        const textLine = `< ${message} >`;
        const cow = `
        \\   ^__^
         \\  (oo)\\_______
            (__)\\       )\\/\\
                ||----w |
                ||     ||
        `;
        return [{ text: `${topLine}\n${textLine}\n${bottomLine}${cow}`, preformatted: true }];
    },

    reboot: () => {
        return { action: 'async', type: 'reboot_system' };
    },
  };

  const runBootSequence = () => {
    const bootMessages = ["Starting system...", "Loading kernel modules...", "Mounting /system...", "Starting services...", "Boot completed."];
    let currentOutput = [];
    bootMessages.forEach((msg, index) => {
      setTimeout(() => {
        currentOutput.push({ id: Date.now() + index, type: 'response', content: [{ text: `[${index+1}/${bootMessages.length}] ${msg}`, style: 'highlight' }] });
        setOutput([...currentOutput]);
      }, 200 * (index + 1));
    });
    setTimeout(() => {
      setOutput(prev => [
        ...prev, 
        { id: Date.now() + 100, type: 'response', content: [{ text: 'Welcome to OrbitOS', style: 'highlight' }] },
        { id: Date.now() + 101, type: 'response', content: [{ text: "Type 'help' for a list of commands" }] }
      ]);
      setSystemBricked(false);
      inputRef.current?.focus();
    }, 200 * (bootMessages.length + 2));
  };
  
  useEffect(() => {
    generateDynamicStorage();
    runBootSequence();
  }, []);
  
  const handleCommand = (command) => {
    if (isSystemBricked) {
        setOutput(prev => [...prev, { id: Date.now(), type: 'response', content: [{ text: 'System halted. Please reboot.', style: 'error' }] }]);
        return;
    }

    const trimmedCommand = command.trim();
    const newOutput = [...output, { id: Date.now() + 1, type: 'command', text: `${promptSymbol}${trimmedCommand}` }];
    
    if (trimmedCommand) {
      if (!commandHistory.includes(trimmedCommand)) {
        setCommandHistory(prev => [...prev, trimmedCommand]);
      }
      setHistoryIndex(commandHistory.length);
      
      const [cmd, ...args] = trimmedCommand.split(' ');
      const commandFunc = commands[cmd.toLowerCase()];
      
      if (commandFunc) {
        const response = commandFunc(args.join(' '));
        if (response && response.action === 'async') {
            if(response.type === 'software_update') {
                newOutput.push({ id: Date.now() + 2, type: 'response', content: [{ text: 'Checking for updates...', style: 'success' }] });
                setTimeout(() => setOutput(prev => [...prev, { id: Date.now() + 3, type: 'response', content: [{ text: 'No new updates found.', style: 'error' }] }]), 1500);
            } else if (response.type === 'reboot_system') {
                newOutput.push({ id: Date.now() + 4, type: 'response', content: [{ text: 'Rebooting system...' }] });
                setOutput(newOutput);
                setTimeout(() => { setOutput([]); runBootSequence(); }, 1500);
                return;
            }
        } else if (response && response.length > 0) {
            newOutput.push({ id: Date.now() + 5, type: 'response', content: response });
        }
      } else {
        newOutput.push({ id: Date.now() + 6, type: 'response', content: [{ text: `Command not found: ${cmd}`, style: 'error' }] });
      }
      setOutput(newOutput);
    } else {
        setOutput(newOutput);
    }
  };

  const renderOutputLine = ({ item }) => {
    const baseTextStyle = { ...styles.outputText, fontFamily };
    if (item.type === 'command') {
      return <Text style={baseTextStyle}>{item.text}</Text>;
    }
    return (
      <View>
        {item.content.map((part, index) => (
          <Text key={index} style={[baseTextStyle, styles[part.style], part.preformatted && styles.preformatted]}>
            {part.text}
          </Text>
        ))}
      </View>
    );
  };
  
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" />
      <KeyboardAvoidingView behavior={Platform.OS === "ios" ? "padding" : "height"} style={styles.terminal}>
        <View style={styles.header}>
            <View style={styles.controls}><View style={styles.dot} /><View style={styles.dot} /><View style={styles.dot} /></View>
            <Text style={styles.title}>OrbitOS Terminal</Text>
        </View>

        <FlatList 
          ref={flatListRef}
          data={output}
          renderItem={renderOutputLine}
          keyExtractor={(item) => item.id.toString()}
          style={styles.outputArea}
          onContentSizeChange={() => flatListRef.current.scrollToEnd({ animated: true })}
        />

        <View style={styles.command}>
          <Text style={[styles.prompt, {fontFamily}]}>{promptSymbol}</Text>
          <TextInput
            ref={inputRef}
            style={[styles.input, {fontFamily}]}
            value={input}
            onChangeText={setInput}
            onSubmitEditing={() => { handleCommand(input); setInput(''); }}
            autoCapitalize="none"
            autoCorrect={false}
            selectionColor={colors.accent}
            underlineColorAndroid="transparent"
            editable={!isSystemBricked}
            blurOnSubmit={false}
          />
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};

// --- Styles ---
const colors = {
    surface: '#1a1c1e',
    surfaceContainer: '#2e3133',
    onSurface: '#e2e2e5',
    accent: '#00b4d8',
    error: '#ff4444',
    success: '#00c853',
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#141517' },
  terminal: { flex: 1, backgroundColor: colors.surface, margin: 5, borderRadius: 16, overflow: 'hidden', borderWidth: 1, borderColor: 'rgba(255, 255, 255, 0.1)' },
  header: { backgroundColor: colors.surfaceContainer, paddingVertical: 10, paddingHorizontal: 15, flexDirection: 'row', alignItems: 'center', borderBottomWidth: 1, borderColor: 'rgba(255, 255, 255, 0.1)' },
  controls: { flexDirection: 'row', gap: 8, marginRight: 12 },
  dot: { width: 12, height: 12, borderRadius: 6, backgroundColor: 'rgba(255, 255, 255, 0.2)' },
  title: { color: colors.accent, fontSize: 14, fontWeight: '500' },
  outputArea: { flex: 1, padding: 15 },
  outputText: { color: colors.onSurface, fontSize: 14, lineHeight: 22 },
  highlight: { color: colors.accent, fontWeight: '500' },
  error: { color: colors.error },
  success: { color: colors.success },
  preformatted: { fontFamily: 'monospace', lineHeight: 16 },
  command: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 15, paddingVertical: 12, backgroundColor: colors.surfaceContainer, borderTopWidth: 1, borderColor: 'rgba(255, 255, 255, 0.1)' },
  prompt: { color: colors.accent, fontSize: 14, marginRight: 8 },
  input: { flex: 1, color: colors.onSurface, fontSize: 14, padding: 0 },
});

export default App;


