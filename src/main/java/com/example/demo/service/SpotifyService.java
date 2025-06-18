package com.example.demo.service;

import com.example.demo.dto.Album;
import com.example.demo.dto.Track;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Service
public class SpotifyService {

    @Value("${spotify.client-id}")
    private String clientId;

    @Value("${spotify.client-secret}")
    private String clientSecret;

    @Value("${spotify.redirect-uri}")
    private String redirectUri;


    private final RestTemplate restTemplate = new RestTemplate();

    public String getAccessToken() {
        String auth = clientId + ":" + clientSecret;
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes());

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Basic " + encodedAuth);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<String> request = new HttpEntity<>("grant_type=client_credentials", headers);

        ResponseEntity<String> response = restTemplate.postForEntity(
                "https://accounts.spotify.com/api/token",
                request,
                String.class
        );

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            return root.path("access_token").asText();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Album> getNewReleases() {
        String accessToken = getAccessToken();
        if (accessToken == null) return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        String url = "https://api.spotify.com/v1/browse/new-releases?limit=20";

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode albumsNode = root.path("albums").path("items");

            List<Album> albums = new ArrayList<>();
            Set<String> seen = new HashSet<>();

            for (JsonNode item : albumsNode) {
                String id = item.path("id").asText();
                if (seen.contains(id)) continue;
                seen.add(id);

                Album album = new Album();
                album.setSpotifyId(id);
                album.setTitle(item.path("name").asText());
                album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                album.setArtist(item.path("artists").get(0).path("name").asText());
                album.setReleaseDate(item.path("release_date").asText());
                album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());

                albums.add(album);
            }

            return albums;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Album> searchAlbums(String keyword) {
        String accessToken = getAccessToken();
        if (accessToken == null) return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        String encodedKeyword = keyword.replace(" ", "%20");
        String url = "https://api.spotify.com/v1/search?q=" + encodedKeyword + "&type=album&limit=50";

        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                entity,
                String.class
        );

        List<Album> albums = new ArrayList<>();

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode items = root.path("albums").path("items");
            String keywordLower = keyword.trim().toLowerCase();

            for (JsonNode item : items) {
                String artistName = item.path("artists").get(0).path("name").asText();
                String albumTitle = item.path("name").asText();

                if (!(artistName.toLowerCase().contains(keywordLower) || albumTitle.toLowerCase().contains(keywordLower))) {
                    continue;
                }

                Album album = new Album();
                album.setSpotifyId(item.path("id").asText());
                album.setTitle(albumTitle);
                album.setArtist(artistName);
                album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                album.setReleaseDate(item.path("release_date").asText());
                album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
                album.setGenre("Unknown");

                albums.add(album);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return albums;
    }

    public List<Album> searchAlbumsByType(String keyword, String type) {
        String accessToken = getAccessToken();
        if (accessToken == null) return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);
        String searchPrefix = type.equals("artist") ? "artist:" : "album:";
        String url = "https://api.spotify.com/v1/search?q=" + searchPrefix + encodedKeyword + "&type=album&limit=50";

        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                entity,
                String.class
        );

        List<Album> albums = new ArrayList<>();
        Set<String> albumKeys = new HashSet<>();
        String keywordLower = keyword.trim().toLowerCase();

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode items = root.path("albums").path("items");

            for (JsonNode item : items) {
                String albumType = item.path("album_type").asText(); // album, single, compilation
                int totalTracks = item.path("total_tracks").asInt();
                JsonNode artists = item.path("artists");

                // 정규 앨범만 필터링: 싱글, 컴필레이션, 참여곡, 아티스트 3명 이상, 트랙 2곡 이하는 제외
                if (!albumType.equalsIgnoreCase("album")) continue;
                if (totalTracks <= 2) continue; // 싱글 회피용
                if (artists.size() > 2) continue; // 참여곡/컴필레벨의 다중 아티스트 필터링
                
                String title = item.path("name").asText().toLowerCase();
                if (title.contains("greatest") || title.contains("hits") || title.contains("best") || title.contains("playlist") || title.contains("collection")) {
                    continue; // 컴필레이션 느낌나는 제목 제거
                }

                String artist = artists.get(0).path("name").asText();

                // 기존 필터 유지
                if (!(title.startsWith(keywordLower) || artist.toLowerCase().startsWith(keywordLower))) {
                    continue;
                }

                String uniqueKey = title.trim() + "|" + artist.toLowerCase().trim();
                if (albumKeys.contains(uniqueKey)) continue;
                albumKeys.add(uniqueKey);

                Album album = new Album();
                album.setSpotifyId(item.path("id").asText());
                album.setTitle(item.path("name").asText());
                album.setArtist(artist);
                album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                album.setReleaseDate(item.path("release_date").asText());
                album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
                album.setGenre("Unknown");

                albums.add(album);
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

        return albums;
    }

    public List<Album> searchAlbumsByTypeWithOffset(String keyword, String type) {
        String accessToken = getAccessToken();
        if (accessToken == null) return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);
        String searchPrefix = type.equals("artist") ? "artist:" : "album:";
        String keywordLower = keyword.trim().toLowerCase();

        List<Album> albums = new ArrayList<>();
        Set<String> albumKeys = new HashSet<>();

        int offset = 0;
        int limit = 50;
        int maxPages = 5;
        int pagesFetched = 0;

        try {
            while (pagesFetched < maxPages) {
                String url = "https://api.spotify.com/v1/search?q=" + searchPrefix + encodedKeyword +
                        "&type=album&limit=" + limit + "&offset=" + offset;

                ResponseEntity<String> response = restTemplate.exchange(
                        url,
                        HttpMethod.GET,
                        entity,
                        String.class
                );

                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(response.getBody());
                JsonNode items = root.path("albums").path("items");

                if (!items.isArray() || items.size() == 0) break;

                for (JsonNode item : items) {
                    String albumType = item.path("album_type").asText();
                    int totalTracks = item.path("total_tracks").asInt();

                    if (albumType.equalsIgnoreCase("single") || totalTracks <= 2) continue;

                    String title = item.path("name").asText();
                    String artist = item.path("artists").get(0).path("name").asText();

                    if (!(title.toLowerCase().startsWith(keywordLower) || artist.toLowerCase().startsWith(keywordLower)))
                        continue;

                    String key = title.toLowerCase().trim() + "|" + artist.toLowerCase().trim();
                    if (albumKeys.contains(key)) continue;
                    albumKeys.add(key);

                    Album album = new Album();
                    album.setSpotifyId(item.path("id").asText());
                    album.setTitle(title);
                    album.setArtist(artist);
                    album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                    album.setReleaseDate(item.path("release_date").asText());
                    album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
                    album.setGenre("Unknown");

                    albums.add(album);
                }

                offset += limit;
                pagesFetched++;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return albums;
    }
    public List<Album> searchAlbumsByGenre(String genre) {
        String accessToken = getAccessToken();
        if (accessToken == null) return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        String encodedGenre = URLEncoder.encode(genre, StandardCharsets.UTF_8);
        String url = "https://api.spotify.com/v1/search?q=" + encodedGenre + "&type=album&limit=50";

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode items = root.path("albums").path("items");

            List<Album> albums = new ArrayList<>();
            Set<String> seen = new HashSet<>();

            for (JsonNode item : items) {
                String albumType = item.path("album_type").asText();
                int totalTracks = item.path("total_tracks").asInt();
                JsonNode artists = item.path("artists");
                String title = item.path("name").asText().toLowerCase();

                if (!albumType.equalsIgnoreCase("album")) continue;
                if (totalTracks <= 2) continue;
                if (artists.size() > 2) continue;
                if (title.contains("hits") || title.contains("playlist") || title.contains("greatest") || title.contains("collection")) continue;

                String uniqueKey = title + "|" + artists.get(0).path("name").asText().toLowerCase().trim();
                if (seen.contains(uniqueKey)) continue;
                seen.add(uniqueKey);

                Album album = new Album();
                album.setSpotifyId(item.path("id").asText());
                album.setTitle(item.path("name").asText());
                album.setArtist(artists.get(0).path("name").asText());
                album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                album.setReleaseDate(item.path("release_date").asText());
                album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
                album.setGenre(genre);
                albums.add(album);
            }

            return albums;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return Collections.emptyList();
    }

    
    public Album getAlbumDetailById(String spotifyId) {
        String accessToken = getAccessToken();
        String url = "https://api.spotify.com/v1/albums/" + spotifyId;

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<String> response = restTemplate.exchange(
                url, HttpMethod.GET, entity, String.class
        );

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode item = mapper.readTree(response.getBody());

            Album album = new Album();
            album.setSpotifyId(item.path("id").asText());
            album.setTitle(item.path("name").asText());
            album.setArtist(item.path("artists").get(0).path("name").asText());
            album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
            album.setReleaseDate(item.path("release_date").asText());
            album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
            album.setGenre("Unknown");

            return album;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<Track> getTracksByAlbumId(String albumId) {
        String url = "https://api.spotify.com/v1/albums/" + albumId + "/tracks?limit=50";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(getAccessToken());
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<Map> response = restTemplate.exchange(
            url,
            HttpMethod.GET,
            entity,
            Map.class
        );

        List<Track> result = new ArrayList<>();

        if (response.getStatusCode().is2xxSuccessful()) {
            List<Map<String, Object>> items = (List<Map<String, Object>>) response.getBody().get("items");

            for (Map<String, Object> item : items) {
                Track track = new Track();
                track.setName((String) item.get("name"));

                int durationMs = (int) item.get("duration_ms");
                int min = durationMs / 60000;
                int sec = (durationMs % 60000) / 1000;
                String duration = String.format("%d:%02d", min, sec);

                track.setDuration(duration);
                result.add(track);
            }

        }

        return result;
    }

    public Album getAlbumDetail(String spotifyId) {
        String url = "https://api.spotify.com/v1/albums/" + spotifyId;

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(getAccessToken());
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<Map> response = restTemplate.exchange(
            url,
            HttpMethod.GET,
            entity,
            Map.class
        );

        if (!response.getStatusCode().is2xxSuccessful()) {
            throw new RuntimeException("앨범 정보 가져오기 실패");
        }

        Map<String, Object> body = response.getBody();

        Album album = new Album();
        album.setSpotifyId(spotifyId);
        album.setTitle((String) body.get("name"));

        List<Map<String, Object>> artists = (List<Map<String, Object>>) body.get("artists");
        if (!artists.isEmpty()) {
            album.setArtist((String) artists.get(0).get("name"));
        }

        album.setReleaseDate((String) body.get("release_date"));
        album.setCoverImgUrl((String) ((Map<String, Object>) ((List<?>) body.get("images")).get(0)).get("url"));
        album.setSpotifyUrl((String) body.get("external_urls") != null
            ? (String) ((Map<String, Object>) body.get("external_urls")).get("spotify")
            : null);

        return album;
    }
    
    public List<String> getRecentlyPlayed(String accessToken) {
        String url = "https://api.spotify.com/v1/me/player/recently-played?limit=10";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<String> response = new RestTemplate().exchange(url, HttpMethod.GET, entity, String.class);

        return List.of(response.getBody()); 
    }

    public String exchangeCodeForAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(clientId, clientSecret);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("code", code);
        params.add("redirect_uri", redirectUri); 

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity("https://accounts.spotify.com/api/token", request, Map.class);
        return (String) response.getBody().get("access_token");
    }

    public String getSpotifyUserProfileUrl(String accessToken) {
        String endpoint = "https://api.spotify.com/v1/me";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        RestTemplate restTemplate = new RestTemplate();

        ResponseEntity<Map> response = restTemplate.exchange(
            endpoint, HttpMethod.GET, entity, Map.class
        );

        Map<String, Object> body = response.getBody();
        if (body != null && body.containsKey("external_urls")) {
            Map<String, String> urls = (Map<String, String>) body.get("external_urls");
            return urls.get("spotify");
        }

        return null;
    }






    



}
