# GridView Gallery

# DISCLAIMER
**This Company and Application are completely fictional.**
These have been created for the purpose of Learning:
- Manage a Project E2E by collecting the requirement to a TestFlight publication.
- Build with Swift/SwiftUI

---

## 🎯 Project Vision
**"Visual organization, simple and elegant"**

GridView Gallery is an iOS application built with SwiftUI that helps creative professionals curate and organize visual references effortlessly. This app allows users to create visual collections, add images from multiple sources, and organize them with tags directly from their iPhone, without the noise and distraction of social features.

## ✨ MVP Features

### Image & List Management (CRUD)
- **Create lists/projects** to organize images by theme or client
- **Add images** from Photo Library or via iOS Share Sheet (AppIntent)
- **Edit images** with title, description, and tags after adding
- **Delete images** with confirmation dialog
- **Edit lists** to rename or delete collections
- **Drag & drop** to reorder images within lists

### Visual Organization
- **Pinterest-style dynamic grid** with variable image heights
- **Multiple viewing modes**: Browse specific lists or view all images globally
- **Tag-based filtering** to quickly find images
- **Search functionality** by tags or keywords
- **Lazy loading** for smooth performance with many images

### Metadata & Curation
- **Tag system** for flexible categorization (#minimal, #vintage, #colorful, etc.)
- **Image details** with title, description, tags, and date added
- **Quick tagging** during image addition or later via edit
- **Origin tracking** showing which list an image belongs to

### User Experience Philosophy
- **Radical simplicity**: No social features, no distractions
- **Local-first**: 100% private, no cloud sync in MVP
- **Speed**: From idea to saved image in under 10 seconds
- **Visual-first**: Grid view as primary experience
- **Zero friction**: No unnecessary popups or confirmations

## 📱 Screenshots

| Projects | Home | Images Details | Add Image | Search |
|:---:|:---:|:---:|:---:|:---:|
| <img width="200" alt="Lists overview with thumbnails" src="https://github.com/user-attachments/assets/6ef54515-d316-4efe-9ddf-471690f974c9" /> | <img width="200" alt="Pinterest-style grid layout" src="https://github.com/user-attachments/assets/b45bf03f-4013-4d3b-b4f5-be9e700f7cae" /> | <img width="200" alt="Full-screen image with metadata" src="https://github.com/user-attachments/assets/8881463d-b09e-48e6-acab-64ea492f9589" /> | <img width="200" alt="Add images with optional tags" src="https://github.com/user-attachments/assets/9df8133a-28a6-4d63-81c4-151ef92344af" /> | <img width="200" alt="Search and filter by tags" src="https://github.com/user-attachments/assets/2d2c1982-19b4-43d0-9a1e-32f461847ce8" /> |

## 🎨 Design

### Color Palette
- **Charcoal Black**: #36454F (text, icons, neutral elements)
- **Rose Gold**: #E8B4B8 (primary buttons, active states, selected tags)

### Design Principles
- **Clean & Minimal**: Avoid visual clutter
- **Breathing Space**: Generous padding and spacing
- **Content First**: Images are the hero
- **Subtle Animations**: Smooth, not distracting
- **iOS Native**: Follows Apple's Human Interface Guidelines

### Theme Support
- **Light mode**: White/Off-white backgrounds
- **Dark mode**: Deep charcoal/black backgrounds
- **Automatic**: Respects system preferences

## 🔧 Technical Architecture

### Technologies
- **Framework**: SwiftUI
- **Database**: SwiftData (local storage)
- **Share Integration**: Share Extension for iOS
- **Image Management**: Local cache with performance optimization
- **Permissions**: Photo Library access

### Performance Optimizations
- **Lazy loading**
- **Intelligent caching**: Optimized memory management

## 🎯 Target Users

**Creative Professionals (25-45 years old)**
- Graphic & UI/UX designers
- Independent photographers
- Interior architects
- Digital illustrators
- Art directors in agencies

**Common Characteristics**
- Use iOS as primary work tool
- Value efficiency and simplicity
- Work on multiple projects simultaneously
- Need quick access to references on the go
- Appreciate clean, aesthetic design

## 📦 Backlog (Out of MVP Scope)

Features NOT included in the initial 4-week development:
- Display customization (column count, spacing adjustments)
- Image or list sharing capabilities
- Statistics (image count, most used tags)
- iCloud synchronization

## 🚀 Use Cases

### Scenario 1 - Designer working on a logo
1. Creates a list "Logo Client ABC"
2. Adds 15-20 logo references they like
3. Tags by style: #minimal, #vintage, #colorful
4. During client meeting, opens the list, filters by #minimal
5. Presents relevant references

### Scenario 2 - Photographer preparing a shoot
1. Creates list "Wedding Shoot June"
2. Adds poses, lighting setups, decor ideas
3. Tags: #pose, #lighting, #decor
4. On shoot day, filters by #pose to quickly find references

### Scenario 3 - Interior architect
1. Creates lists by room: "Modern Living Room", "Scandinavian Kitchen"
2. Collects images during daily inspiration browsing
3. During design phase, navigates between lists
4. Reorganizes by drag & drop according to preferences

## 🎓 Key Skills Developed

- Staggered grids with variable heights (Pinterest-style)
- Dynamic feeds and lazy loading
- Modern, elegant design implementation
- Share Extension integration for iOS
- Performance optimization with image-heavy apps
- Local-first data architecture with SwiftData

---

## 📄 License
This project is under MIT License. See the [LICENSE](LICENSE) file for more details.
