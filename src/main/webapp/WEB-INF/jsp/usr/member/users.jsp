<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
  body {
    background-color: #f5f5f5;
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
    padding: 0;
  }

  .profile-container {
    max-width: 700px;
    margin: 50px auto;
    background: #fff;
    border-radius: 9px;
    padding: 30px;
    box-shadow: 0 0 10px rgba(0,0,0,0.06);
  }

  .profile-header {
    display: flex;
    align-items: center;
    gap: 24px;
    margin-bottom: 10px;
  }

  .profile-header img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background-color: #eee;
    object-fit: cover;
  }

  .profile-info {
    flex: 1;
  }

  .profile-info h2 {
    font-size: 20px;
    margin: 0;
    color: #222;
  }

  .profile-info p {
    margin-top: 6px;
    color: #777;
    font-size: 14px;
  }

  .section-divider {
    border: none;
    border-top: 1px solid #eee;
    margin: 20px 0 16px 0;
  }

  .edit-button-wrap {
    text-align: center;
    margin-bottom: 20px;
  }

  .edit-profile-btn {
    background: #f9f9f9;
    color: #7E7E7E;
    border: 1px solid #ccc;
    padding: 12px 24px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.2s ease;
    border-radius: 12px;
  }

  .edit-profile-btn:hover {
    background: #f0f0f0;
    color: #000;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  }

  .stats {
    margin-top: 10px;
    text-align: center;
  }

  .stats .item {
    font-size: 16px;
    font-weight: bold;
    color: #222;
  }

  .stats .label {
    font-size: 13px;
    color: #999;
  }

  #editProfileModal {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    z-index: 9999;
    display: none;
    align-items: center;
    justify-content: center;
    font-family: 'Segoe UI', sans-serif;
  }

  #editProfileModal .modal-content {
    background: white;
    padding: 32px 24px;
    border-radius: 6px;
    text-align: center;
    width: 320px;
    height: 480px;
    position: relative;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  }

  #editProfileModal .modal-logo {
    font-size: 32px;
    font-weight: bold;
    color: #000;
    margin-bottom: 12px;
    padding-top: 50px;
  }

  #editProfileModal .modal-message {
    font-size: 16px;
    color: #4b4b4b;
    margin-bottom: 24px;
    padding-top: 80px;
    padding-bottom: 30px;
    line-height: 1.6;
    font-weight: bold;
  }

  #editProfileModal input {
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 6px;
    width: 100%;
    margin-bottom: 20px;
  }

  #editProfileModal .modal-button {
    display: block;
    width: 100%;
    padding: 10px 0;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    background-color: #000;
    color: white;
    border: none;
  }

  #editProfileModal .modal-close {
    position: absolute;
    top: 12px;
    right: 12px;
    font-size: 18px;
    color: #999;
    background: none;
    border: none;
    cursor: pointer;
  }

  #editProfileModal .modal-close:hover {
    color: #000;
  }
  
  .input-wrap {
  position: relative;
  margin-bottom: 28px;
}

.input-wrap label {
  position: absolute;
  top: -10px;
  left: 0;
  font-size: 12px;
  color: #999;
  background: white;
  padding: 0 4px;
  z-index: 2;
}

.input-wrap input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  font-size: 16px;
  border-radius: 6px;
  outline: none;
  transition: border 0.2s;
}


.input-wrap input:focus {
  border-bottom: 1px solid #000;
}
  
.input-wrap input.error-border {
  border: 1px solid #dc2626 !important;
  border-radius: 6px;
}


.error-msg {
  color: #dc2626;
  font-size: 13px;
  margin-top: 1px;
  text-align: left;
}

  
  
  
</style>

<div class="profile-container">
  <div class="profile-header">
    <img src="https://an2-glx.amz.wtchn.net/assets/default/user/photo_file_name_small-ab0a7f6a92a282859192ba17dd4822023e22273e168c2daf05795e5171e66446.jpg" alt="프로필 이미지">
    <div class="profile-info">
      <h2>
		<span style="display: inline-flex; align-items: center;">
		  ${loginedMember.loginId}
		  
		  <c:if test="${loginedMember != null && loginedMember.connectedToSpotify}">
		    <svg xmlns="http://www.w3.org/2000/svg"
		         viewBox="0 0 496 512"
		         width="18" height="18"
		         style="fill: #1DB954; margin-left: 6px;">
		      <path d="M248 8C111 8 0 119 0 256s111 248 248 248 
		               248-111 248-248S385 8 248 8zm121.8 
		               365.7c-5.3 7.9-15.9 10.1-23.8 4.8-65.6-44.2
		               -148.5-54-245.5-29.6-9.2 2.3-18.5-3.1-20.8
		               -12.3-2.3-9.2 3.1-18.5 12.3-20.8 107.4
		               -27 201.3-15.3 276.1 35.6 7.9 5.3 10.1 15.9
		               4.7 23.9zm31.4-70.1c-6.6 9.9-20 12.9-29.8
		               6.3-74.9-50.4-189.4-65-277.7-35.5-11 3.6
		               -22.8-2.4-26.3-13.4-3.6-11 2.4-22.8 
		               13.4-26.3 102.3-33 231.2-16.4 317.2 
		               41.4 9.8 6.6 12.7 20 6.2 29.7zm33.4-78.9c
		               -8.2 12.3-24.9 15.7-37.2 7.5-85.3-56.7
		               -226.7-61.2-309.8-33.5-13.6 4.4-28.1-3
		               -32.5-16.6-4.4-13.6 3-28.1 16.6-32.5 
		               96.4-31.4 257.4-26.2 356.5 39.8 12.2 
		               8.1 15.6 24.8 7.4 37.3z"/>
		    </svg>
		  </c:if>
		</span>
      </h2>
      <p>${req.getLoginedMember().getEmail()}</p>
    </div>
  </div>

  <hr class="section-divider" />

  <c:if test="${req.loginedMember.id eq profileMember.id}">
    <div class="edit-button-wrap">
      <button onclick="openEditModal()" class="edit-profile-btn">프로필 수정</button>
    </div>
  </c:if>

<a href="/usr/member/ratedAlbums" style="text-decoration: none; color: inherit;">
  <div class="stats">
    <div class="item">${ratingCount}</div>
    <div class="label">평가</div>
  </div>
</a>


</div>

<div id="editProfileModal">
  <div class="modal-content">
    <button class="modal-close" onclick="closeEditModal()">✕</button>
    <div class="modal-logo">AlbumRate</div>
    <div class="modal-message">로그인 ID를 수정할 수 있어요</div>
	<form id="editProfileForm" method="post" action="/usr/member/doModify">
	  <div class="input-wrap">
	    <label for="loginId">이름</label>
	    <input type="text" name="loginId" id="loginId" value="${profileMember.loginId}" />
	    <p id="nameError" class="error-msg" style="display:none;">이름을 입력해주세요.</p>
	    <p id="duplicateError" class="error-msg" style="display:none;">이미 존재하는 이름입니다.</p>
	  </div>
	  <button type="submit" class="modal-button">저장</button>
	</form>


  </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

<script>
function openEditModal() {
  document.getElementById("editProfileModal").style.display = "flex";
}

function closeEditModal() {
  document.getElementById("editProfileModal").style.display = "none";
}

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    document.getElementById("editProfileModal").style.display = "none";
    const loginModal = document.getElementById("loginModal");
    if (loginModal) loginModal.style.display = "none";
  }
});

const loginModal = document.getElementById("loginModal");
if (loginModal) {
  loginModal.addEventListener("click", (e) => {
    const modalContent = loginModal.querySelector(".modal-content");
    if (!modalContent.contains(e.target)) {
      loginModal.style.display = "none";
    }
  });
  loginModal.querySelector(".modal-close")?.addEventListener("click", () => {
    loginModal.style.display = "none";
  });
}

const editProfileModal = document.getElementById("editProfileModal");
if (editProfileModal) {
  editProfileModal.addEventListener("click", (e) => {
    const modalContent = editProfileModal.querySelector(".modal-content");
    if (!modalContent.contains(e.target)) {
      editProfileModal.style.display = "none";
    }
  });
  editProfileModal.querySelector(".modal-close")?.addEventListener("click", () => {
    editProfileModal.style.display = "none";
  });
}

const form = document.getElementById("editProfileForm");
const loginIdInput = document.getElementById("loginId");
const nameError = document.getElementById("nameError");
const duplicateError = document.getElementById("duplicateError");

function showError(msgElem) {
  nameError.style.display = "none";
  duplicateError.style.display = "none";
  loginIdInput.classList.add("error-border");
  msgElem.style.display = "block";
}

function clearError() {
  nameError.style.display = "none";
  duplicateError.style.display = "none";
  loginIdInput.classList.remove("error-border");
}

if (form) {
  form.addEventListener("submit", function (e) {
    e.preventDefault();
    const value = loginIdInput.value.trim();

    clearError();

    if (value.length === 0) {
      showError(nameError);
      return;
    }

    if (value.length < 2) {
      nameError.textContent = "이름은 2자 이상이어야 합니다.";
      showError(nameError);
      return;
    }

    $.ajax({
      url: "/usr/member/checkDuplicate",
      type: "GET",
      data: { loginId: value },
      success: function (data) {
        if (data.exists) {
          showError(duplicateError);
        } else {
          clearError();
          form.submit();
        }
      },
      error: function () {
        showError(nameError);
        nameError.textContent = "중복 확인 중 오류가 발생했습니다.";
      }
    });
  });
}
</script>

