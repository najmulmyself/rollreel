# RollReel 2.0.1 — ASO Update

Goal: rank for higher-download keywords. How iOS search actually weighs
metadata: **App Name > Subtitle > Keyword field**. The Description is NOT
indexed for search (it converts, not ranks). Every locale's keyword field
indexes **separately** — localizing metadata multiplies your indexed surface
at zero risk.

Sources: [Apptweak keyword research guide](https://www.apptweak.com/en/aso-blog/app-store-keyword-research-aso),
[MobileAction ASO research 2026](https://www.mobileaction.co/blog/aso-keyword-research/),
[ASO World long-tail trends 2026](https://asoworld.com/en/blog/summer-2026-app-store-trends-the-long-tail-keyword-shift-what-s-rising-what-s-fading-and-how-to-act-now/),
plus competitor listings (GalleryVault, MaxVault, Private Photo & Video Lock, Gallery: Photos & Videos).

## 1. Strategy

Your winnable clusters (relevance first — a mismatch kw brings browsers, not installs):
1. **"offline / local video player"** — core identity, moderate volume, low-mid difficulty
2. **"gallery / camera roll"** — high volume, real relevance
3. **"vault / hide videos / private"** — very high volume (competitors live here), and you genuinely ship a Face ID vault
4. **"memories / on this day"** — new 2.0.1 feature, low competition, high intent

Head terms like "video player" alone are dominated by VLC-class apps — you rank
via the title as a phrase component, not as a standalone bet. The 2026 long-tail
shift favors exactly your combos: "offline video player", "hide videos gallery",
"camera roll memories".

## 2. English (U.S.) metadata — paste-ready

| Field | Value | Notes |
|---|---|---|
| Title (30) | `RollReel – Local Video Player` | keep — "video player" phrase + brand, 29/30 |
| Subtitle (30) | `Offline Gallery, Vault, Swipe` | 29/30 — adds "offline", "gallery", "vault", "swipe"; replaces the non-searching "Swipe Your Camera Roll Videos" |
| Keywords (100) | `hide,videos,photo,camera,roll,memories,private,slideshow,movie,mp4,secret,album,reel,feed` | 97/100 — no duplicates of title/subtitle words, commas without spaces, singulars (Apple matches plurals) |
| Promo text (170) | `NEW: On This Day memories, 13 languages, and a faster feed. Swipe your camera roll 100% offline — no uploads, no account, no tracking.` | editable anytime without review |

Why these keywords: Apple combines title+subtitle+keyword-field terms into
phrases ("hide videos", "photo vault" via vault in subtitle + photo in field,
"camera roll", "private gallery", "memories reel"). Never repeat a word across
fields — it wastes characters.

## 3. What's New (EN)

```
What's new in 2.0.1
• On This Day — relive videos from this date in past years (Pro)
• RollReel now speaks 13 languages
• Smoother feed: videos preload before you swipe
• Faster app launch
```

## 4. Localized metadata (all 12 locales — paste into each locale in ASC)

Subtitle ≤30 chars, keyword field ≤100. Title stays `RollReel – Local Video Player`-equivalent; keep "RollReel" latin everywhere.

| Locale | Title (30) | Subtitle (30) | Keywords (100) |
|---|---|---|---|
| es-MX / es-ES | `RollReel – Reproductor Local` | `Galería offline y bóveda` | `ocultar,videos,privado,carrete,recuerdos,fotos,secreto,álbum,sin conexión,reel,deslizar` |
| zh-Hans | `RollReel – 本地视频播放器` | `离线相册·私密保险箱` | `隐藏视频,私密相册,回忆,本地播放,滑动,保险库,照片,视频管理,离线,秘密` |
| hi | `RollReel – लोकल वीडियो प्लेयर` | `ऑफ़लाइन गैलरी और वॉल्ट` | `वीडियो छिपाएं,निजी,गैलरी,कैमरा रोल,यादें,फोटो,सीक्रेट,एल्बम,ऑफलाइन,रील` |
| ar | `RollReel – مشغل فيديو محلي` | `معرض بلا إنترنت وخزنة` | `إخفاء,فيديو,خاص,البوم,ذكريات,صور,سري,قفل,بدون انترنت,معرض` |
| pt-BR | `RollReel – Player de Vídeo` | `Galeria offline e cofre` | `esconder,videos,privado,rolo,câmera,memórias,fotos,secreto,álbum,deslizar,reel` |
| fr | `RollReel – Lecteur Vidéo Local` | `Galerie hors ligne et coffre` | `cacher,vidéos,privé,pellicule,souvenirs,photos,secret,album,verrou,balayer` |
| de | `RollReel – Lokaler Videoplayer` | `Offline-Galerie & Tresor` | `videos,verstecken,privat,aufnahmen,erinnerungen,fotos,geheim,album,sperren,wischen` |
| ja | `RollReel – ローカル動画プレーヤー` | `オフライン写真・動画金庫` | `動画,隠す,プライベート,カメラロール,思い出,写真,シークレット,アルバム,ロック,スワイプ` |
| ko | `RollReel – 로컬 동영상 플레이어` | `오프라인 갤러리·비밀 금고` | `동영상,숨기기,사진,카메라롤,추억,비공개,앨범,잠금,오프라인,스와이프` |
| ru | `RollReel – Локальный плеер` | `Офлайн-галерея и сейф` | `скрыть,видео,приватный,галерея,воспоминания,фото,секрет,альбом,блокировка,лента` |
| it | `RollReel – Player Video Locale` | `Galleria offline e cassaforte` | `nascondere,video,privato,rullino,ricordi,foto,segreto,album,blocco,scorrere` |
| tr | `RollReel – Yerel Video Oynatıcı` | `Çevrimdışı galeri ve kasa` | `video,gizle,özel,kamera rulosu,anılar,fotoğraf,gizli,albüm,kilit,kaydır` |

Localized What's New: translate the EN block via the same phrasing used in the
app's arb files (On This Day = the `onThisDay` translation per locale — keeps
store copy consistent with in-app copy).

Screenshot/preview overlay headlines per locale: reuse the arb translations —
shot 1 `onboardingSubtitle` (shortened), shot 2 `featureOnThisDay` + `featureOnThisDaySub`,
shot 3 `onboardingPrivacyBody` (first sentence), shot 5 `featureVault` + `featureVaultSub`.

## 5. Description (EN) — conversion only, not indexed

Keep the current 2.0-era description, add at the top of WHY ROLLREEL:

```
• NEW — On This Day: relive videos from this date in past years
• NEW — Available in 13 languages
```

Keep the Terms of Use (EULA) + Privacy Policy links at the bottom
(App Review requirement — do not remove):

```
Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
Privacy Policy: https://najmulmyself.github.io/rollreel/privacy.html
```

## 6. Post-launch iteration loop

- Promo text: editable **without** a new build/review — refresh monthly with the current hook.
- Keyword field & subtitle: changeable **only with a version submission** — batch changes with app updates.
- Week 2–3 after release: check Search tab in App Analytics → impressions by search term. Kill keywords with 0 impressions, promote converting phrases toward subtitle.
- If "vault" queries convert well, consider testing subtitle `Hide Videos · Offline Gallery` in 2.0.2 via Product Page Optimization (A/B) rather than guessing.
