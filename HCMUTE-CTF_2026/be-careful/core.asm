
C:\Users\Phuc\Downloads\chall:     file format elf64-x86-64


Disassembly of section .text:

0000000000401971 <.text+0x871>:
  401971:	55                   	push   rbp
  401972:	48 89 e5             	mov    rbp,rsp
  401975:	53                   	push   rbx
  401976:	48 83 ec 50          	sub    rsp,0x50
  40197a:	48 89 7d c0          	mov    QWORD PTR [rbp-0x40],rdi
  40197e:	89 75 bc             	mov    DWORD PTR [rbp-0x44],esi
  401981:	89 d0                	mov    eax,edx
  401983:	48 89 4d b0          	mov    QWORD PTR [rbp-0x50],rcx
  401987:	4c 89 45 a8          	mov    QWORD PTR [rbp-0x58],r8
  40198b:	88 45 b8             	mov    BYTE PTR [rbp-0x48],al
  40198e:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  401995:	c7 45 f0 00 00 00 00 	mov    DWORD PTR [rbp-0x10],0x0
  40199c:	e9 0c 03 00 00       	jmp    0x401cad
  4019a1:	8b 55 f0             	mov    edx,DWORD PTR [rbp-0x10]
  4019a4:	89 d0                	mov    eax,edx
  4019a6:	c1 e0 02             	shl    eax,0x2
  4019a9:	01 d0                	add    eax,edx
  4019ab:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
  4019ae:	0f b6 55 b8          	movzx  edx,BYTE PTR [rbp-0x48]
  4019b2:	8b 4d ec             	mov    ecx,DWORD PTR [rbp-0x14]
  4019b5:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  4019b9:	89 ce                	mov    esi,ecx
  4019bb:	48 89 c7             	mov    rdi,rax
  4019be:	e8 74 ff ff ff       	call   0x401937
  4019c3:	88 45 eb             	mov    BYTE PTR [rbp-0x15],al
  4019c6:	0f b6 55 b8          	movzx  edx,BYTE PTR [rbp-0x48]
  4019ca:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  4019cd:	83 c0 01             	add    eax,0x1
  4019d0:	89 c1                	mov    ecx,eax
  4019d2:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  4019d6:	89 ce                	mov    esi,ecx
  4019d8:	48 89 c7             	mov    rdi,rax
  4019db:	e8 57 ff ff ff       	call   0x401937
  4019e0:	88 45 ea             	mov    BYTE PTR [rbp-0x16],al
  4019e3:	0f b6 55 b8          	movzx  edx,BYTE PTR [rbp-0x48]
  4019e7:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  4019ea:	83 c0 02             	add    eax,0x2
  4019ed:	89 c1                	mov    ecx,eax
  4019ef:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  4019f3:	89 ce                	mov    esi,ecx
  4019f5:	48 89 c7             	mov    rdi,rax
  4019f8:	e8 3a ff ff ff       	call   0x401937
  4019fd:	88 45 e9             	mov    BYTE PTR [rbp-0x17],al
  401a00:	0f b6 55 b8          	movzx  edx,BYTE PTR [rbp-0x48]
  401a04:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  401a07:	83 c0 03             	add    eax,0x3
  401a0a:	89 c1                	mov    ecx,eax
  401a0c:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  401a10:	89 ce                	mov    esi,ecx
  401a12:	48 89 c7             	mov    rdi,rax
  401a15:	e8 1d ff ff ff       	call   0x401937
  401a1a:	0f b6 d8             	movzx  ebx,al
  401a1d:	0f b6 55 b8          	movzx  edx,BYTE PTR [rbp-0x48]
  401a21:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  401a24:	83 c0 04             	add    eax,0x4
  401a27:	89 c1                	mov    ecx,eax
  401a29:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  401a2d:	89 ce                	mov    esi,ecx
  401a2f:	48 89 c7             	mov    rdi,rax
  401a32:	e8 00 ff ff ff       	call   0x401937
  401a37:	0f b6 c0             	movzx  eax,al
  401a3a:	c1 e0 08             	shl    eax,0x8
  401a3d:	09 d8                	or     eax,ebx
  401a3f:	89 45 e4             	mov    DWORD PTR [rbp-0x1c],eax
  401a42:	0f b6 45 eb          	movzx  eax,BYTE PTR [rbp-0x15]
  401a46:	3d ff 00 00 00       	cmp    eax,0xff
  401a4b:	0f 84 52 02 00 00    	je     0x401ca3
  401a51:	3d ff 00 00 00       	cmp    eax,0xff
  401a56:	0f 8f 4c 02 00 00    	jg     0x401ca8
  401a5c:	83 f8 09             	cmp    eax,0x9
  401a5f:	0f 84 a8 01 00 00    	je     0x401c0d
  401a65:	83 f8 09             	cmp    eax,0x9
  401a68:	0f 8f 3a 02 00 00    	jg     0x401ca8
  401a6e:	83 f8 08             	cmp    eax,0x8
  401a71:	0f 84 60 01 00 00    	je     0x401bd7
  401a77:	83 f8 08             	cmp    eax,0x8
  401a7a:	0f 8f 28 02 00 00    	jg     0x401ca8
  401a80:	83 f8 07             	cmp    eax,0x7
  401a83:	0f 84 0d 02 00 00    	je     0x401c96
  401a89:	83 f8 07             	cmp    eax,0x7
  401a8c:	0f 8f 16 02 00 00    	jg     0x401ca8
  401a92:	83 f8 06             	cmp    eax,0x6
  401a95:	0f 84 f3 01 00 00    	je     0x401c8e
  401a9b:	83 f8 06             	cmp    eax,0x6
  401a9e:	0f 8f 04 02 00 00    	jg     0x401ca8
  401aa4:	83 f8 05             	cmp    eax,0x5
  401aa7:	0f 84 92 01 00 00    	je     0x401c3f
  401aad:	83 f8 05             	cmp    eax,0x5
  401ab0:	0f 8f f2 01 00 00    	jg     0x401ca8
  401ab6:	83 f8 04             	cmp    eax,0x4
  401ab9:	0f 84 e3 00 00 00    	je     0x401ba2
  401abf:	83 f8 04             	cmp    eax,0x4
  401ac2:	0f 8f e0 01 00 00    	jg     0x401ca8
  401ac8:	83 f8 03             	cmp    eax,0x3
  401acb:	0f 84 85 00 00 00    	je     0x401b56
  401ad1:	83 f8 03             	cmp    eax,0x3
  401ad4:	0f 8f ce 01 00 00    	jg     0x401ca8
  401ada:	83 f8 01             	cmp    eax,0x1
  401add:	74 0a                	je     0x401ae9
  401adf:	83 f8 02             	cmp    eax,0x2
  401ae2:	74 4b                	je     0x401b2f
  401ae4:	e9 bf 01 00 00       	jmp    0x401ca8
  401ae9:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401aed:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401af1:	48 01 d0             	add    rax,rdx
  401af4:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401af7:	88 45 d3             	mov    BYTE PTR [rbp-0x2d],al
  401afa:	0f b6 55 e9          	movzx  edx,BYTE PTR [rbp-0x17]
  401afe:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401b02:	48 01 d0             	add    rax,rdx
  401b05:	0f b6 4d ea          	movzx  ecx,BYTE PTR [rbp-0x16]
  401b09:	48 8b 55 a8          	mov    rdx,QWORD PTR [rbp-0x58]
  401b0d:	48 01 ca             	add    rdx,rcx
  401b10:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401b13:	88 02                	mov    BYTE PTR [rdx],al
  401b15:	0f b6 55 e9          	movzx  edx,BYTE PTR [rbp-0x17]
  401b19:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401b1d:	48 01 c2             	add    rdx,rax
  401b20:	0f b6 45 d3          	movzx  eax,BYTE PTR [rbp-0x2d]
  401b24:	88 02                	mov    BYTE PTR [rdx],al
  401b26:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401b2a:	e9 7e 01 00 00       	jmp    0x401cad
  401b2f:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401b33:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401b37:	48 01 d0             	add    rax,rdx
  401b3a:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401b3d:	0f b6 4d ea          	movzx  ecx,BYTE PTR [rbp-0x16]
  401b41:	48 8b 55 a8          	mov    rdx,QWORD PTR [rbp-0x58]
  401b45:	48 01 ca             	add    rdx,rcx
  401b48:	32 45 e9             	xor    al,BYTE PTR [rbp-0x17]
  401b4b:	88 02                	mov    BYTE PTR [rdx],al
  401b4d:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401b51:	e9 57 01 00 00       	jmp    0x401cad
  401b56:	0f b6 45 e9          	movzx  eax,BYTE PTR [rbp-0x17]
  401b5a:	c1 e0 08             	shl    eax,0x8
  401b5d:	89 c1                	mov    ecx,eax
  401b5f:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401b63:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401b67:	48 01 d0             	add    rax,rdx
  401b6a:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401b6d:	0f b6 c0             	movzx  eax,al
  401b70:	09 c8                	or     eax,ecx
  401b72:	89 45 d4             	mov    DWORD PTR [rbp-0x2c],eax
  401b75:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401b79:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401b7d:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  401b81:	8b 4d d4             	mov    ecx,DWORD PTR [rbp-0x2c]
  401b84:	48 8b 45 b0          	mov    rax,QWORD PTR [rbp-0x50]
  401b88:	ba 5b 00 00 00       	mov    edx,0x5b
  401b8d:	89 ce                	mov    esi,ecx
  401b8f:	48 89 c7             	mov    rdi,rax
  401b92:	e8 a0 fd ff ff       	call   0x401937
  401b97:	88 03                	mov    BYTE PTR [rbx],al
  401b99:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401b9d:	e9 0b 01 00 00       	jmp    0x401cad
  401ba2:	0f b6 55 e9          	movzx  edx,BYTE PTR [rbp-0x17]
  401ba6:	0f b6 4d ea          	movzx  ecx,BYTE PTR [rbp-0x16]
  401baa:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401bae:	48 01 c8             	add    rax,rcx
  401bb1:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401bb4:	0f b6 c0             	movzx  eax,al
  401bb7:	0f b6 75 ea          	movzx  esi,BYTE PTR [rbp-0x16]
  401bbb:	48 8b 4d a8          	mov    rcx,QWORD PTR [rbp-0x58]
  401bbf:	48 8d 1c 0e          	lea    rbx,[rsi+rcx*1]
  401bc3:	89 d6                	mov    esi,edx
  401bc5:	89 c7                	mov    edi,eax
  401bc7:	e8 d9 fc ff ff       	call   0x4018a5
  401bcc:	88 03                	mov    BYTE PTR [rbx],al
  401bce:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401bd2:	e9 d6 00 00 00       	jmp    0x401cad
  401bd7:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401bdb:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401bdf:	48 01 d0             	add    rax,rdx
  401be2:	0f b6 30             	movzx  esi,BYTE PTR [rax]
  401be5:	0f b6 55 e9          	movzx  edx,BYTE PTR [rbp-0x17]
  401be9:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401bed:	48 01 d0             	add    rax,rdx
  401bf0:	0f b6 08             	movzx  ecx,BYTE PTR [rax]
  401bf3:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401bf7:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401bfb:	48 01 d0             	add    rax,rdx
  401bfe:	31 ce                	xor    esi,ecx
  401c00:	89 f2                	mov    edx,esi
  401c02:	88 10                	mov    BYTE PTR [rax],dl
  401c04:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401c08:	e9 a0 00 00 00       	jmp    0x401cad
  401c0d:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401c11:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401c15:	48 01 d0             	add    rax,rdx
  401c18:	0f b6 30             	movzx  esi,BYTE PTR [rax]
  401c1b:	0f b6 55 e9          	movzx  edx,BYTE PTR [rbp-0x17]
  401c1f:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401c23:	48 01 d0             	add    rax,rdx
  401c26:	0f b6 08             	movzx  ecx,BYTE PTR [rax]
  401c29:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401c2d:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401c31:	48 01 d0             	add    rax,rdx
  401c34:	8d 14 0e             	lea    edx,[rsi+rcx*1]
  401c37:	88 10                	mov    BYTE PTR [rax],dl
  401c39:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401c3d:	eb 6e                	jmp    0x401cad
  401c3f:	0f b6 45 e9          	movzx  eax,BYTE PTR [rbp-0x17]
  401c43:	d0 e8                	shr    al,1
  401c45:	0f b6 c0             	movzx  eax,al
  401c48:	83 e0 07             	and    eax,0x7
  401c4b:	89 45 e0             	mov    DWORD PTR [rbp-0x20],eax
  401c4e:	0f b6 45 e9          	movzx  eax,BYTE PTR [rbp-0x17]
  401c52:	83 e0 01             	and    eax,0x1
  401c55:	89 45 dc             	mov    DWORD PTR [rbp-0x24],eax
  401c58:	0f b6 55 ea          	movzx  edx,BYTE PTR [rbp-0x16]
  401c5c:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
  401c60:	48 01 d0             	add    rax,rdx
  401c63:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401c66:	0f b6 d0             	movzx  edx,al
  401c69:	8b 45 e0             	mov    eax,DWORD PTR [rbp-0x20]
  401c6c:	89 c1                	mov    ecx,eax
  401c6e:	d3 fa                	sar    edx,cl
  401c70:	89 d0                	mov    eax,edx
  401c72:	83 e0 01             	and    eax,0x1
  401c75:	89 45 d8             	mov    DWORD PTR [rbp-0x28],eax
  401c78:	8b 45 d8             	mov    eax,DWORD PTR [rbp-0x28]
  401c7b:	3b 45 dc             	cmp    eax,DWORD PTR [rbp-0x24]
  401c7e:	75 06                	jne    0x401c86
  401c80:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401c84:	eb 27                	jmp    0x401cad
  401c86:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  401c89:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
  401c8c:	eb 1f                	jmp    0x401cad
  401c8e:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  401c91:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
  401c94:	eb 17                	jmp    0x401cad
  401c96:	0f b6 45 ea          	movzx  eax,BYTE PTR [rbp-0x16]
  401c9a:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
  401c9d:	83 45 f0 01          	add    DWORD PTR [rbp-0x10],0x1
  401ca1:	eb 0a                	jmp    0x401cad
  401ca3:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  401ca6:	eb 1a                	jmp    0x401cc2
  401ca8:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  401cab:	eb 15                	jmp    0x401cc2
  401cad:	83 7d f0 00          	cmp    DWORD PTR [rbp-0x10],0x0
  401cb1:	78 0c                	js     0x401cbf
  401cb3:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
  401cb6:	3b 45 bc             	cmp    eax,DWORD PTR [rbp-0x44]
  401cb9:	0f 8c e2 fc ff ff    	jl     0x4019a1
  401cbf:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  401cc2:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
  401cc6:	c9                   	leave
  401cc7:	c3                   	ret
