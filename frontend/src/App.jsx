import './App.css'; // Importar los estilos CSS
import React, { useState, useMemo, useEffect } from 'react';

// Configuración de la API
const API_BASE_URL = 'http://localhost:3001/api';

function MinecraftWordleGame() {
  const [category, setCategory] = useState('items');
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [selectedItem, setSelectedItem] = useState(null);
  const [targetItem, setTargetItem] = useState(null);
  const [gameStarted, setGameStarted] = useState(false);
  const [guesses, setGuesses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState(null);

  // Fetch stats on component mount
  useEffect(() => {
    fetchStats();
  }, []);

  // Search items when search term changes
  useEffect(() => {
    if (searchTerm.trim().length > 0 && gameStarted && !isGameWon) {
      searchItems();
    } else {
      setSearchResults([]);
    }
  }, [searchTerm, category, guesses]);

  const fetchStats = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/stats`);
      if (response.ok) {
        const data = await response.json();
        setStats(data);
      }
    } catch (error) {
      console.error('Error obteniendo estadísticas:', error);
    }
  };

  const searchItems = async () => {
    if (!searchTerm.trim()) {
      setSearchResults([]);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const excludeNames = guesses.map(guess => guess.name);
      const excludeParams = excludeNames.length > 0 ? 
        `&${excludeNames.map(name => `exclude=${encodeURIComponent(name)}`).join('&')}` : '';
      
      const response = await fetch(
        `${API_BASE_URL}/${category}/search?q=${encodeURIComponent(searchTerm)}${excludeParams}`
      );

      if (!response.ok) {
        throw new Error(`Error HTTP! estado: ${response.status}`);
      }

      const data = await response.json();
      setSearchResults(data);
    } catch (error) {
      console.error('Error buscando elementos:', error);
      setError('Error buscando elementos. Por favor intenta de nuevo.');
      setSearchResults([]);
    } finally {
      setLoading(false);
    }
  };

  const startGame = async () => {
    setLoading(true);
    setError(null);

    try {
      const response = await fetch(`${API_BASE_URL}/${category}/random`);
      
      if (!response.ok) {
        throw new Error(`Error HTTP! estado: ${response.status}`);
      }

      const randomItem = await response.json();
      
      // Convert database fields to match frontend expectations
      const convertedItem = convertDatabaseItem(randomItem, category);
      
      setTargetItem(convertedItem);
      setGameStarted(true);
      setGuesses([]);
      setSelectedItem(null);
      setSearchTerm('');
      setSearchResults([]);
    } catch (error) {
      console.error('Error iniciando juego:', error);
      setError('Error iniciando juego. Por favor intenta de nuevo.');
    } finally {
      setLoading(false);
    }
  };

  const convertDatabaseItem = (item, cat) => {
    if (cat === 'items') {
      return {
        name: item.name,
        release: item.release,
        stackSize: item.stack_size,
        rarity: item.rarity,
        creativeCategory: item.creative_category,
        whereCrafted: item.where_crafted
        // Removido howToObtain
      };
    } else if (cat === 'mobs') {
      return {
        name: item.name,
        release: item.release,
        health: item.health,
        height: parseFloat(item.height),
        behavior: item.behavior,
        spawnCategory: item.spawn_category
      };
    } else { // blocks
      return {
        name: item.name,
        release: item.release,
        stackSize: item.stack_size,
        tool: item.tool,
        hardness: parseFloat(item.hardness),
        blastResistance: parseFloat(item.blast_resistance),
        flammable: item.flammable,
        fullBlock: item.full_block
      };
    }
  };

  const makeGuess = async (guessedItem) => {
    if (!targetItem || guesses.find(g => g.name === guessedItem.name)) return;
    
    setLoading(true);
    
    try {
      // Convert database item to match frontend format
      const convertedGuess = convertDatabaseItem(guessedItem, category);
      
      const comparison = compareItems(convertedGuess, targetItem, category);
      setGuesses([...guesses, { ...convertedGuess, comparison }]);
      setSearchTerm('');
      setSearchResults([]);
    } catch (error) {
      console.error('Error haciendo intento:', error);
      setError('Error haciendo intento. Por favor intenta de nuevo.');
    } finally {
      setLoading(false);
    }
  };

  // Función helper para comparar versiones de Minecraft
  const compareVersions = (version1, version2) => {
    // Función simple para comparar versiones (puedes mejorarla según tus necesidades)
    const parseVersion = (v) => {
      const parts = v.replace(/[^\d.]/g, '').split('.');
      return parts.map(p => parseInt(p) || 0);
    };
    
    const v1 = parseVersion(version1);
    const v2 = parseVersion(version2);
    
    for (let i = 0; i < Math.max(v1.length, v2.length); i++) {
      const a = v1[i] || 0;
      const b = v2[i] || 0;
      if (a < b) return 'up';
      if (a > b) return 'down';
    }
    return null;
  };

  const compareItems = (guess, target, cat) => {
    const comparison = {};
    
    if (cat === 'items') {
      comparison.name = guess.name === target.name ? 'correct' : 'incorrect';
      
      if (guess.release === target.release) {
        comparison.release = 'correct';
      } else {
        comparison.release = 'incorrect';
        comparison.releaseDirection = compareVersions(guess.release, target.release);
      }
      
      if (guess.stackSize === target.stackSize) {
        comparison.stackSize = 'correct';
      } else if (Math.abs(guess.stackSize - target.stackSize) <= 16) {
        comparison.stackSize = 'partial';
        comparison.stackSizeDirection = guess.stackSize > target.stackSize ? 'down' : 'up';
      } else {
        comparison.stackSize = 'incorrect';
        comparison.stackSizeDirection = guess.stackSize > target.stackSize ? 'down' : 'up';
      }
      
      comparison.rarity = guess.rarity === target.rarity ? 'correct' : 'incorrect';
      comparison.creativeCategory = guess.creativeCategory === target.creativeCategory ? 'correct' : 'incorrect';
      comparison.whereCrafted = guess.whereCrafted === target.whereCrafted ? 'correct' : 'incorrect';
    } else if (cat === 'mobs') {
      comparison.name = guess.name === target.name ? 'correct' : 'incorrect';
      
      if (guess.release === target.release) {
        comparison.release = 'correct';
      } else {
        comparison.release = 'incorrect';
        comparison.releaseDirection = compareVersions(guess.release, target.release);
      }
      
      if (guess.health === target.health) {
        comparison.health = 'correct';
      } else if (Math.abs(guess.health - target.health) <= 10) {
        comparison.health = 'partial';
        comparison.healthDirection = guess.health > target.health ? 'down' : 'up';
      } else {
        comparison.health = 'incorrect';
        comparison.healthDirection = guess.health > target.health ? 'down' : 'up';
      }
      
      if (guess.height === target.height) {
        comparison.height = 'correct';
      } else if (Math.abs(guess.height - target.height) <= 0.5) {
        comparison.height = 'partial';
        comparison.heightDirection = guess.height > target.height ? 'down' : 'up';
      } else {
        comparison.height = 'incorrect';
        comparison.heightDirection = guess.height > target.height ? 'down' : 'up';
      }
      
      comparison.behavior = guess.behavior === target.behavior ? 'correct' : 'incorrect';
      comparison.spawnCategory = guess.spawnCategory === target.spawnCategory ? 'correct' : 'incorrect';
    } else { // blocks
      comparison.name = guess.name === target.name ? 'correct' : 'incorrect';
      
      if (guess.release === target.release) {
        comparison.release = 'correct';
      } else {
        comparison.release = 'incorrect';
        comparison.releaseDirection = compareVersions(guess.release, target.release);
      }
      
      comparison.stackSize = guess.stackSize === target.stackSize ? 'correct' : 'incorrect';
      comparison.tool = guess.tool === target.tool ? 'correct' : 'incorrect';
      
      if (guess.hardness === target.hardness) {
        comparison.hardness = 'correct';
      } else if (Math.abs(guess.hardness - target.hardness) <= 1) {
        comparison.hardness = 'partial';
        comparison.hardnessDirection = guess.hardness > target.hardness ? 'down' : 'up';
      } else {
        comparison.hardness = 'incorrect';
        comparison.hardnessDirection = guess.hardness > target.hardness ? 'down' : 'up';
      }
      
      if (guess.blastResistance === target.blastResistance) {
        comparison.blastResistance = 'correct';
      } else if (Math.abs(guess.blastResistance - target.blastResistance) <= 5) {
        comparison.blastResistance = 'partial';
        comparison.blastResistanceDirection = guess.blastResistance > target.blastResistance ? 'down' : 'up';
      } else {
        comparison.blastResistance = 'incorrect';
        comparison.blastResistanceDirection = guess.blastResistance > target.blastResistance ? 'down' : 'up';
      }
      
      comparison.flammable = guess.flammable === target.flammable ? 'correct' : 'incorrect';
      comparison.fullBlock = guess.fullBlock === target.fullBlock ? 'correct' : 'incorrect';
    }
    
    return comparison;
  };

  const handleCategoryChange = (newCategory) => {
    setCategory(newCategory);
    // Reset game state when changing category
    if (gameStarted) {
      setGameStarted(false);
      setGuesses([]);
      setTargetItem(null);
      setSearchTerm('');
      setSearchResults([]);
    }
  };

  // Función helper para mostrar valores con flechas
  const renderValueWithArrow = (value, comparison, property) => {
    const direction = comparison?.[`${property}Direction`];
    const arrow = direction === 'up' ? '↑' : direction === 'down' ? '↓' : '';
    
    return (
      <span>
        {value} {arrow && <span className={`arrow arrow-${direction}`}>{arrow}</span>}
      </span>
    );
  };

  const renderItemProperties = (item, comparison = null) => {
    if (category === 'items') {
      return (
        <div className="property-grid-items">
          <div className={`property-cell ${comparison?.name ? `property-${comparison.name}` : ''}`}>
            <strong>Nombre:</strong>
            <span>{item.name}</span>
          </div>
          <div className={`property-cell ${comparison?.release ? `property-${comparison.release}` : ''}`}>
            <strong>Versión:</strong>
            {renderValueWithArrow(item.release, comparison, 'release')}
          </div>
          <div className={`property-cell ${comparison?.stackSize ? `property-${comparison.stackSize}` : ''}`}>
            <strong>Tamaño de pila:</strong>
            {renderValueWithArrow(item.stackSize, comparison, 'stackSize')}
          </div>
          <div className={`property-cell ${comparison?.rarity ? `property-${comparison.rarity}` : ''}`}>
            <strong>Rareza:</strong>
            <span>{item.rarity}</span>
          </div>
          <div className={`property-cell ${comparison?.creativeCategory ? `property-${comparison.creativeCategory}` : ''}`}>
            <strong>Categoría:</strong>
            <span>{item.creativeCategory}</span>
          </div>
          <div className={`property-cell ${comparison?.whereCrafted ? `property-${comparison.whereCrafted}` : ''}`}>
            <strong>Se fabrica en:</strong>
            <span>{item.whereCrafted}</span>
          </div>
        </div>
      );
    } else if (category === 'mobs') {
      return (
        <div className="property-grid-mobs">
          <div className={`property-cell ${comparison?.name ? `property-${comparison.name}` : ''}`}>
            <strong>Nombre:</strong>
            <span>{item.name}</span>
          </div>
          <div className={`property-cell ${comparison?.release ? `property-${comparison.release}` : ''}`}>
            <strong>Versión:</strong>
            {renderValueWithArrow(item.release, comparison, 'release')}
          </div>
          <div className={`property-cell ${comparison?.health ? `property-${comparison.health}` : ''}`}>
            <strong>Vida:</strong>
            {renderValueWithArrow(item.health, comparison, 'health')}
          </div>
          <div className={`property-cell ${comparison?.height ? `property-${comparison.height}` : ''}`}>
            <strong>Altura:</strong>
            {renderValueWithArrow(`${item.height}m`, comparison, 'height')}
          </div>
          <div className={`property-cell ${comparison?.behavior ? `property-${comparison.behavior}` : ''}`}>
            <strong>Comportamiento:</strong>
            <span>{item.behavior}</span>
          </div>
          <div className={`property-cell ${comparison?.spawnCategory ? `property-${comparison.spawnCategory}` : ''}`}>
            <strong>Aparición:</strong>
            <span>{item.spawnCategory}</span>
          </div>
        </div>
      );
    } else { // blocks
      return (
        <div className="property-grid-blocks">
          <div className={`property-cell ${comparison?.name ? `property-${comparison.name}` : ''}`}>
            <strong>Nombre:</strong>
            <span>{item.name}</span>
          </div>
          <div className={`property-cell ${comparison?.release ? `property-${comparison.release}` : ''}`}>
            <strong>Versión:</strong>
            {renderValueWithArrow(item.release, comparison, 'release')}
          </div>
          <div className={`property-cell ${comparison?.stackSize ? `property-${comparison.stackSize}` : ''}`}>
            <strong>Tamaño de pila:</strong>
            <span>{item.stackSize}</span>
          </div>
          <div className={`property-cell ${comparison?.tool ? `property-${comparison.tool}` : ''}`}>
            <strong>Herramienta:</strong>
            <span>{item.tool}</span>
          </div>
          <div className={`property-cell ${comparison?.hardness ? `property-${comparison.hardness}` : ''}`}>
            <strong>Dureza:</strong>
            {renderValueWithArrow(item.hardness, comparison, 'hardness')}
          </div>
          <div className={`property-cell ${comparison?.blastResistance ? `property-${comparison.blastResistance}` : ''}`}>
            <strong>Resist. explosión:</strong>
            {renderValueWithArrow(item.blastResistance, comparison, 'blastResistance')}
          </div>
          <div className={`property-cell ${comparison?.flammable ? `property-${comparison.flammable}` : ''}`}>
            <strong>Inflamable:</strong>
            <span>{item.flammable ? 'Sí' : 'No'}</span>
          </div>
          <div className={`property-cell ${comparison?.fullBlock ? `property-${comparison.fullBlock}` : ''}`}>
            <strong>Bloque completo:</strong>
            <span>{item.fullBlock ? 'Sí' : 'No'}</span>
          </div>
        </div>
      );
    }
  };

  const isGameWon = guesses.length > 0 && guesses[guesses.length - 1].name === targetItem?.name;

  return (
    <div className="game-container">
      <h1 className="game-title">Juego Diario de Palabras de Minecraft</h1>
      
      {stats && (
        <div className="stats-display">
          La base de datos contiene: {stats.items} objetos, {stats.mobs} mobs, {stats.blocks} bloques ({stats.total} total)
        </div>
      )}
      
      <div className="game-controls">
        <div className="category-selector">
          {[
            { key: 'items', label: 'Objetos' },
            { key: 'mobs', label: 'Mobs' },
            { key: 'blocks', label: 'Bloques' }
          ].map((cat) => (
            <button
              key={cat.key}
              className={`category-tab ${category === cat.key ? 'active' : ''}`}
              onClick={() => handleCategoryChange(cat.key)}
            >
              {cat.label}
            </button>
          ))}
        </div>
        
        <div className="start-game-container">
          <button 
            className="mc-button" 
            onClick={startGame} 
            disabled={loading}
          >
            {loading ? 'Cargando...' : (gameStarted ? 'Nuevo Juego' : 'Iniciar Juego')}
          </button>
        </div>
      </div>

      {error && (
        <div className="error-message">
          {error}
        </div>
      )}

      {gameStarted && !isGameWon && (
        <div className="search-container">
          <input
            type="text"
            className="mc-input"
            placeholder={`Buscar ${category === 'items' ? 'un objeto' : category === 'mobs' ? 'un mob' : 'un bloque'}...`}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            disabled={loading}
          />
          {loading && <span className="search-loading">Buscando...</span>}
          
          {searchResults.length > 0 && (
            <div className="search-results">
              {searchResults.map((item, index) => (
                <div
                  key={index}
                  className="search-result-item"
                  onClick={() => makeGuess(item)}
                >
                  {item.name}
                </div>
              ))}
            </div>
          )}
          
          {searchTerm && searchResults.length === 0 && !loading && (
            <div className="no-results">
              No se encontraron resultados para "{searchTerm}"
            </div>
          )}
        </div>
      )}

      {gameStarted && (
        <div className="guesses-section">
          <h3>Tus intentos: {guesses.length}</h3>
          <div className="legend">
            <span className="legend-item legend-correct">Verde</span> <span className='xd'> = Correcto </span>
            <span className="legend-item legend-partial">Amarillo</span> <span className='xd'> = Cerca </span>
            <span className="legend-item legend-incorrect">Rojo</span> <span className='xd'> = Incorrecto </span>
            <span className="legend-item">↑↓</span> <span className='xd'> = Mayor/Menor </span>
          </div>
          
          {guesses.map((guess, index) => (
            <div key={index}>
              {renderItemProperties(guess, guess.comparison)}
            </div>
          ))}
          
          {isGameWon && (
            <div className="victory-message">
              <h2>🎉 ¡Felicidades! ¡Lo adivinaste! 🎉</h2>
              <p>Encontraste el {category === 'items' ? 'objeto' : category === 'mobs' ? 'mob' : 'bloque'} correcto en {guesses.length} {guesses.length === 1 ? 'intento' : 'intentos'}!</p>
              <p><strong>Respuesta:</strong> {targetItem?.name}</p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

export default MinecraftWordleGame;