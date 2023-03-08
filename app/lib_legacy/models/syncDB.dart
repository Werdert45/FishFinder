class syncDB {
    List achievements;
    String email;
    Map friends_catches;
    List friends_id;
    String language;
    List species;
    String uid;


    syncDB(
        this.achievements,
        this.email,
        this.friends_catches,
        this.friends_id,
        this.language,
        this.species,
        this.uid
        );

    @override
    Map<dynamic, dynamic> toJSON() {
        return {
            'achievements': this.achievements,
            'email': this.email,
            'friends_catches': this.friends_catches,
            'friends_id': this.friends_id,
            'language': this.language,
            'species': this.species,
            'uid': this.uid
        };
    }
}