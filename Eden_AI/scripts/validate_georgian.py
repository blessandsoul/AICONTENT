import sys
import os
import re

# Banned phrases mapping: Pattern -> Reason/Fix
BANNED_PHRASES = {
    # Russian Calques & Bad Translations
    r"ავიყვან შედეგზე": "Rus Calque: 'Выведу на результат'. Fix: 'მივიყვან შედეგამდე'.",
    r"გადავცემ ჩემს ტვინს": "Unnatural: 'Передам мозг'. Fix: 'გაგიზიარებთ გამოცდილებას' or 'ვასწავლი'.",
    r"გადავცემ ტვინს": "Unnatural: 'Передам мозг'.",
    r"წყლის ნაყვა": "Cliche: 'Toloch vodu'. Use stronger idiom.",
    
    # Structural Bans
    r"ეს არ არის .* ეს არის": "Contrast Trap: 'This is not X, it is Y'. Be direct.",
    r"ეს არ არის": "Potential Contrast Trap. Check context.",
    
    # Specific User Bans (Context: Fake Courses)
    r"ქარხნებს": "Metaphor Fail: User hates 'Factories'. Use 'Systems'.",
    r"ჯადოსნურ სიტყვებს": "Cliche: 'Magic words'. Use 'Technical terms'.",
    r"პრომპტ ინჟინერი": "Dead Profession: User considers this a scam. Attack it, don't use it as a title.",
    
    # Generic AI Cliches (Georgian)
    r"ციფრულ ეპოქაში": "Generic Filler: 'In the digital era'. Delete.",
    r"მომავალი აქ არის": "Cliche: 'The future is here'. Delete.",
    r"რევოლუციური": "Hype word: 'Revolutionary'. Be specific.",
}

def check_file(filepath):
    print(f"\n🔍 SCANNING: {os.path.basename(filepath)}")
    print("=" * 40)
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return

    violations = []
    
    for i, line in enumerate(lines):
        line_num = i + 1
        content = line.strip()
        
        if not content:
            continue
            
        for pattern, reason in BANNED_PHRASES.items():
            if re.search(pattern, content, re.IGNORECASE):
                violations.append({
                    "line": line_num,
                    "content": content,
                    "match": pattern,
                    "reason": reason
                })

    if not violations:
        print("✅ PASSED: No banned idioms or structures found.")
    else:
        print(f"⚠️ FOUND {len(violations)} VIOLATIONS:")
        for v in violations:
            print(f"  [Line {v['line']}] ❌ Found: '{v['match']}'")
            print(f"     reason: {v['reason']}")
            print(f"     content: \"{v['content'][:50]}...\"")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_georgian.py <file_path>")
        sys.exit(1)
        
    target_path = sys.argv[1]
    if os.path.exists(target_path):
        check_file(target_path)
    else:
        print(f"File not found: {target_path}")
