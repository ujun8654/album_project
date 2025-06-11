package com.example.demo.service;

import com.example.demo.dto.Album;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
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
                String albumType = item.path("album_type").asText();
                int totalTracks = item.path("total_tracks").asInt();

                if (albumType.equalsIgnoreCase("single") || totalTracks <= 2) {
                    continue;
                }

                String title = item.path("name").asText();
                String artist = item.path("artists").get(0).path("name").asText();

                if (!(title.toLowerCase().startsWith(keywordLower) || artist.toLowerCase().startsWith(keywordLower))) {
                    continue;
                }

                String uniqueKey = title.toLowerCase().trim() + "|" + artist.toLowerCase().trim();
                if (albumKeys.contains(uniqueKey)) {
                    continue;
                }
                albumKeys.add(uniqueKey);

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
        String url = "https://api.spotify.com/v1/search?q=" + encodedGenre + "&type=album&limit=20";

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
            for (JsonNode item : items) {
                Album album = new Album();
                album.setSpotifyId(item.path("id").asText());
                album.setTitle(item.path("name").asText());
                album.setArtist(item.path("artists").get(0).path("name").asText());
                album.setCoverImgUrl(item.path("images").get(0).path("url").asText());
                album.setReleaseDate(item.path("release_date").asText());
                album.setSpotifyUrl(item.path("external_urls").path("spotify").asText());
                album.setGenre(genre);
                albums.add(album);
            }

            return albums;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
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



}
